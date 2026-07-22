[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string[]]$Path = @('*.exe')
)

$ErrorActionPreference = 'Stop'

$files = @(Get-ChildItem -Path $Path -File)
if ($files.Count -eq 0) {
    throw "No files matched: $($Path -join ', ')"
}

foreach ($file in $files) {
    $signature = Get-AuthenticodeSignature -FilePath $file.FullName
    $signer = if ($null -ne $signature.SignerCertificate) {
        $signature.SignerCertificate.Subject
    }
    else {
        '<none>'
    }
    $timestamp = if ($null -ne $signature.TimeStamperCertificate) {
        $signature.TimeStamperCertificate.Subject
    }
    else {
        '<none>'
    }

    Write-Output "Verifying $($file.FullName)"
    Write-Output "  Status: $($signature.Status)"
    Write-Output "  Signer: $signer"
    Write-Output "  Timestamp authority: $timestamp"

    if ($signature.Status -ne [System.Management.Automation.SignatureStatus]::Valid) {
        throw "Authenticode verification failed for '$($file.FullName)': $($signature.Status) - $($signature.StatusMessage)"
    }
}
