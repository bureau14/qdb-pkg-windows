#!/bin/bash

rest_file=`ls qdb-*rest.zip`
if [[ ${rest_file} =~ (qdb-(.+)-windows-64bit-rest.zip$) ]]; then
    VERSION=${BASH_REMATCH[2]}
fi  
echo "VERSION=$VERSION"

server_file=`ls qdb-*server.zip`
if [[ ${server_file} =~ (qdb-.+-windows-(64|32)bit-server.zip$) ]]; then
    BITS=${BASH_REMATCH[2]}
fi

echo "BITS=$BITS"

if [ $BITS = "64" ]; then
    SETUP=qdb-$VERSION-windows-64bit-setup
else
    SETUP=qdb-$VERSION-windows-32bit-setup
fi

echo "SETUP=$SETUP"

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

if [ $BITS = "64" ]; then
    iscc qdb-server-64.iss -dQdbSetupBaseName=$SETUP -dQdbVersion=$VERSION -dQdbIs64bit=1 -dQdbOutputDir=qdb
else
    iscc qdb-server-32.iss -dQdbSetupBaseName=$SETUP -dQdbVersion=$VERSION -dQdbIs64bit=0 -dQdbOutputDir=qdb
fi

echo "##teamcity[blockClosed name='iscc']"