#!/bin/bash

server_file=`ls qdb-*server.zip`
if [[ ${server_file} =~ (qdb-.+-windows-(64|32)bit-server.zip$) ]]; then
    BITS=${BASH_REMATCH[2]}
fi
echo "BITS=$BITS"

if [[ ${server_file} =~ (qdb-(.+)-windows-(64|32)bit-server.zip$) ]]; then
    VERSION=${BASH_REMATCH[2]}
fi  
echo "VERSION=$VERSION"

[[ $BITS = "64" ]] && SETUP=qdb-$VERSION-windows-64bit-setup || SETUP=qdb-$VERSION-windows-32bit-setup
echo "SETUP=$SETUP"

[[ $BITS = "64" ]] && ODBC_SETUP=qdb-odbc-driver-$VERSION-windows-64bit-setup || ODBC_SETUP=qdb-$VERSION-windows-32bit-setup
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
iscc qdb-server.iss -dQdbSetupBaseName=$ODBC_SETUP -dQdbVersion=$VERSION -dQdbIs64bit=$QDBIS64 -dQdbOutputDir=qdb

echo "##teamcity[blockClosed name='iscc']"