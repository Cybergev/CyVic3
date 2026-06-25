$path = "common\buy_packages\mod_buy_packages.txt"
if (-not (Test-Path $path)) {
    Write-Error "File not found: $path"
    exit 1
}
$lines = Get-Content $path -Encoding UTF8
$exact = 5.0
$count = 0
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match '^\s*(popneed_household_items\s*=\s*)(\d+)\s*$') {
        if ($count -ne 0) {
            $exact = $exact * 1.12
        }
        $new = [math]::Floor($exact)
        $lines[$i] = "$($matches[1])$new"
        $count++
    }
}
[System.IO.File]::WriteAllLines($path, $lines, [System.Text.Encoding]::UTF8)
Write-Output "Updated popneed_household_items entries: $count"
Get-Content $path | Select-String '^\s*popneed_household_items\s*=\s*\d+' | ForEach-Object { $_.Line }
