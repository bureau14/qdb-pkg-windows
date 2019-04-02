#!/bin/sh
set -eu -o pipefail
IFS=$'\n\t'

if [[ $# -ne 1 ]] ; then
    >&2 echo "Usage: $0 <new_version>"
    exit 1
fi

INPUT_VERSION=$1; shift

XYZB_VERSION=${INPUT_VERSION%%-*}
CURRENT_YEAR=`date +%Y`

cd $(dirname -- $0)
cd ${PWD}/../..

# AppCopyright=Copyright (C) 2009-2017 quasardb SAS
sed -i -e 's/AppCopyright=\(.*2009-\)[0-9]\+/AppCopyright=\1'"${CURRENT_YEAR}"'/' qdb-server.iss
