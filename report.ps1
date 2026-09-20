param([string]$Output = "system-report.json")
$report = [ordered]@{
    generatedAt = (Get-Date).ToUniversalTime().ToString("o")
    computer = $env:COMPUTERNAME
    user = $env:USERNAME
    os = (Get-CimInstance Win32_OperatingSystem).Caption
    memoryGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    disks = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object { [ordered]@{name=$_.DeviceID; freeGB=[math]::Round($_.FreeSpace/1GB,2); sizeGB=[math]::Round($_.Size/1GB,2)} })
}
$report | ConvertTo-Json -Depth 4 | Set-Content -Encoding utf8 $Output
Write-Host "Reporte creado en $Output"
