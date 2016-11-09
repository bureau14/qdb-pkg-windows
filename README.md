quasardb Windows installer
--------------------------

This repository contains the source code of the Windows installer for [quasardb](https://www.quasardb.net/).

## Requirements:

* Inno Setup

## Instructions

1. Download and unzip the following binaries into `qdb/`:
   * `qdb-2.0.0-windows-32bit-c-api.zip` or `qdb-2.0.0-windows-64bit-c-api.zip`
   * `qdb-2.0.0-windows-32bit-server.zip` or `qdb-2.0.0-windows-64bit-server.zip`
   * `qdb-2.0.0-windows-32bit-utils.zip` or `qdb-2.0.0-windows-64bit-utils.zip`
   * `qdb-2.0.0-windows-32bit-web-bridge.zip` or `qdb-2.0.0-windows-64bit-web-bridge.zip`
2. Open `qdb-server.iss` in Inno Setup
3. Optionaly add a `;` to comment out the `SignTool=` line (if you don't have the certificate)
4. Compile :-)

## Node

* `pack.bat` is used by the continuous integration server
