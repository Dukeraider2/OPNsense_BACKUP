# ICX7150 TFTP preflight
# Read-only: this script does not change adapter settings, switch configuration, or firmware.
# Run in PowerShell on the PC that will serve the files.

$ErrorActionPreference = "Stop"

$AdapterAlias = "1gb Network"
$ExpectedIPv4 = "192.0.2.2"
$ExpectedPrefixLength = 24
$TftpRoot = Join-Path $env:USERPROFILE "Documents\RUCKUS-Backup\Upgrade"
$RequiredFiles = @(
    "mnz10114.bin",
    "SPS08080f.bin",
    "SPS08095sufi.bin"
)

$adapter = Get-NetAdapter -Name $AdapterAlias -ErrorAction Stop
if ($adapter.Status -ne "Up") {
    throw "Adapter '$AdapterAlias' is not Up (status: $($adapter.Status))."
}

$validAddress = Get-NetIPAddress -InterfaceAlias $AdapterAlias -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -eq $ExpectedIPv4 -and
        $_.PrefixLength -eq $ExpectedPrefixLength -and
        $_.AddressState -eq "Preferred"
    } |
    Select-Object -First 1

if (-not $validAddress) {
    throw "Expected $ExpectedIPv4/$ExpectedPrefixLength in Preferred state on '$AdapterAlias'. No changes were made."
}

if (-not (Test-Path -LiteralPath $TftpRoot -PathType Container)) {
    throw "TFTP root folder not found: $TftpRoot"
}

$missing = @(
    foreach ($name in $RequiredFiles) {
        $path = Join-Path $TftpRoot $name
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $name
        }
    }
)

if ($missing.Count -gt 0) {
    throw "Missing required file(s): $($missing -join ', '). No network changes were made."
}

$inventory = foreach ($name in $RequiredFiles) {
    $file = Get-Item -LiteralPath (Join-Path $TftpRoot $name)
    if ($file.Length -le 0) {
        throw "File is empty: $($file.FullName)"
    }

    [pscustomobject]@{
        File   = $file.Name
        Bytes  = $file.Length
        Path   = $file.FullName
    }
}

Write-Host "Adapter and IP confirmed:"
$adapter | Select-Object Name, Status, LinkSpeed | Format-Table -AutoSize
$validAddress | Select-Object IPAddress, PrefixLength, AddressState | Format-Table -AutoSize

Write-Host "Firmware files present (presence/size only; this script does not verify vendor checksums):"
$inventory | Format-Table -AutoSize

Write-Host "IMPORTANT: In Tftpd32, independently confirm Server interface = $ExpectedIPv4 and Current Directory = $TftpRoot."
