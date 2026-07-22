$destination = "./YUBIKEY_PIN.txt"

[System.IO.File]::WriteAllText(
    $destination,
    $env:YUBIKEY_PIN,
    [System.Text.UTF8Encoding]::new($false)
)
