quasardb Windows installer
--------------------------

This repository contains the source code of the Windows installer for [quasardb](https://www.quasardb.net/).

## Requirements:

* Inno Setup

## Instructions

1. [Download](https://www.quasardb.net/-Get-) and unzip the following binaries into `qdb/`:
   * `qdb-*-windows-32bit-c-api.zip` or `qdb-*-windows-64bit-c-api.zip`
   * `qdb-*-windows-32bit-server.zip` or `qdb-*-windows-64bit-server.zip`
   * `qdb-*-windows-32bit-utils.zip` or `qdb-*-windows-64bit-utils.zip`
   * `qdb-*-windows-32bit-web-bridge.zip` or `qdb-*-windows-64bit-web-bridge.zip`
1. Open `qdb-server.iss` in Inno Setup
1. Optionaly add a `;` to comment out the `SignTool=` line (if you don't have the certificate)
1. Compile :-)

## Node

* `pack.bat` is used by the continuous integration server
