#!/bin/bash

server_file=`ls qdb-*server.zip`
if [[ ${server_file} =~ (qdb-(.+)-windows-(64|32)bit(-core2)?-server.zip$) ]]; then
    VERSION=${BASH_REMATCH[2]}
    BITS=${BASH_REMATCH[3]}
    CORE2=${BASH_REMATCH[4]}
fi
echo "BITS=$BITS"
echo "VERSION=$VERSION"
echo "CORE2=$CORE2"

SETUP=qdb-$VERSION-windows-${BITS}bit${CORE2}-setup
echo "SETUP=$SETUP"

ODBC_SETUP=qdb-odbc-driver-$VERSION-windows-${BITS}bit${CORE2}-setup
echo "ODBC_SETUP=$ODBC_SETUP"

[[ $BITS = "64" ]] && QDBIS64=1 || QDBIS64=0
echo "IS 64-BITS=$QDBIS64"

# STEP 1: unzip --------------------------------------------------------------
echo "##teamcity[blockOpened name='unzip' description='Extract artifacts']"
rm -Rf qdb
for f in *.zip; do
    echo "Extracting $f"
    7z x -oqdb -y $f
done

ls -lR qdb

echo "##teamcity[blockClosed name='unzip']"

# STEP 2: compile ------------------------------------------------------------
echo "##teamcity[blockOpened name='iscc' description='Inno Setup']"

iscc qdb-server.iss -dQdbSetupBaseName=$SETUP -dQdbVersion=$VERSION -dQdbIs64bit=$QDBIS64 -dQdbOutputDir=qdb
iscc qdb-odbc-driver.iss -dQdbSetupBaseName=$ODBC_SETUP -dQdbVersion=$VERSION -dQdbIs64bit=$QDBIS64 -dQdbOutputDir=qdb

echo "##teamcity[blockClosed name='iscc']"