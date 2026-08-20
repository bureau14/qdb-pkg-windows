#!/usr/bin/env python3
"""Buildkite dynamic pipeline generator for qdb-api-go.

Step templates in steps/*.yml define nearly-complete Buildkite steps with
{placeholder} variables.  This script loads them, substitutes variables, and
overlays environment variables and the Docker plugin per platform.

Usage:
    python3 pipeline.py           # emit pipeline YAML to stdout
    python3 pipeline.py check     # validate without emitting
"""

from __future__ import annotations

import dataclasses
import sys
from pathlib import Path

from buildkite_sdk import CommandStep, Pipeline, GroupStep

sys.path.insert(0, str(Path(__file__).parent / "tools"))
from qdb_pipeline import (
    Platform,
    load_template,
    merge_env,
    select_platforms,
    validate_pipeline,
    get_git_ref,
    set_artifact_plugin_options,
    apply_docker_compose,
)  # noqa: E402

STEPS_DIR = Path(__file__).parent / "steps"

# Quasardb-specific toolchain overlays on top of shared infrastructure platforms.
_WIN = dict(
)

_OS_OVERLAY = {"windows": _WIN}
PLATFORMS: list[Platform] = [
    dataclasses.replace(p, **_OS_OVERLAY.get(p.os, {}))
    for p in select_platforms("windows-amd64-haswell", "windows-amd64-core2")
]

# We only package release builds
BUILD_TYPES = ["Release"]

# Environment variable layering: global → step → os → os+step → platform compilers.
GLOBAL_ENV: dict[str, str] = {
    "CERTIFICATE_PATH": "./qdb-code-signing/quasardb inc_.crt",
}

STEP_ENV: dict[str, dict[str, str]] = {}

OS_ENV: dict[str, dict[str, str]] = {}

OS_STEP_ENV: dict[str, dict[str, str]] = {}

CPU_ENV: dict[str, dict[str, str]] = {}


def _env(p: Platform, step_name: str, build_type: str) -> dict[str, str]:
    """Compose the full environment dict for one step."""
    return merge_env(
        GLOBAL_ENV,
        STEP_ENV.get(step_name, {}),
        OS_ENV.get(p.os, {}),
        OS_STEP_ENV.get(f"{p.os}/{step_name}", {}),
        CPU_ENV.get(p.cpu, {}),
        {"CMAKE_BUILD_TYPE": build_type},
        platform=p,
    )


def generate_pipeline() -> Pipeline:
    """Load templates, expand across platforms × build_types, overlay env and docker."""
    pipeline = Pipeline()
    git_ref = get_git_ref()

    for p in PLATFORMS:
        for bt in BUILD_TYPES:
            dependency_slug = p.slug(bt.lower())
            slug = p.slug(bt.lower())
            # We want to use Release QuasarDB binaries when building Go API (debug and release)
            dependency_slug = p.slug("release")

            tvars = {
                "slug": slug,
                "name": slug.replace("-", " ").title(),
                "queue": "sign-windows"
            }

            artifact_vars_per_step = {
                "download": {
                    "git_ref": git_ref,
                    "variant": dependency_slug,
                    "by_project": {
                        "qdb-code-signing": {
                            "variant": "build"
                        }
                    }
                },
                "upload": {"variant": slug, "git_ref": git_ref},
                "promote": {"variant": slug, "git_ref": git_ref},
            }

            step = load_template(STEPS_DIR / f"_package.yml", **tvars)
            env = _env(p, "package", bt)
            env.update(step.get("env") or {})
            step["env"] = env
            set_artifact_plugin_options(step, artifact_vars_per_step)
            pipeline.add_step(CommandStep.from_dict(step))

    return pipeline


def main() -> None:
    command = sys.argv[1] if len(sys.argv) > 1 else "generate"

    try:
        pipeline = generate_pipeline()
    except Exception as e:
        print(f"[FAIL] Pipeline generation failed: {e}", file=sys.stderr)
        sys.exit(1)

    if command == "generate":
        print(pipeline.to_yaml())
    elif command == "check":
        errors = validate_pipeline(pipeline)
        if errors:
            for e in errors:
                print(f"[FAIL] {e}", file=sys.stderr)
            sys.exit(1)
        print(f"[OK] Pipeline valid: {len(pipeline.steps)} steps")
    else:
        print(f"Unknown command: {command}", file=sys.stderr)
        print("Usage: pipeline.py [generate|check]", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
