# Get version, bits, and core2 from the server file name
$serverFile = Get-ChildItem "qdb-*server.zip"
$regex = $serverFile.Name | Select-String -Pattern '(qdb-(.+)-windows-(64|32)bit(-core2)?-server.zip$)' 
$version = $regex.Matches.Groups[2].Value
$bits = $regex.Matches.Groups[3].Value
$core2 = $regex.Matches.Groups[4].Value

Write-Output "versions = $version"
Write-Output "bits = $bits"
Write-Output "core2 = $core2"

$serverSetupName = "qdb-$version-windows-$($bits)bits$($core2)-setup"
Write-Output "server setup name = $serverSetupName"

$odbcSetupName = "qdb-odbc-driver-$version-windows-$($bits)bits$($core2)-setup"
Write-Output "odbc setup name = $odbcSetupName"

$qdbIs64 = If ( $bits -eq "64" ) {1} else {0}
echo "Is 64 bits = $qdbIs64"

# Compile
iscc qdb-server.iss /DQdbSetupBaseName=$serverSetupName /DQdbVersion=$version /DQdbIs64bit=$qdbIs64 /DQdbOutputDir=qdb
iscc qdb-odbc-driver.iss /DQdbSetupBaseName=$odbcSetupName /DQdbVersion=$version /DQdbIs64bit=$qdbIs64 /DQdbOutputDir=qdb