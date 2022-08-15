# ========== Update content From here ============
$account_name = 'azure storage resource name'
$connection_String = ''  # ⚠️ caution : have full permisson 
$share_name = 'example_name'
$status = ""
# ========== Update content To here ============
$report = "Report $(Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }).csv"

# SPV File (SP is some sort of folder name that used as root folder -> format [sp/version{x}])
$SPV_Content = Get-Content .\SPV-test.txt

Add-Content $report "Line Number, SPV, Status"

foreach ($item in $SPV_Content) {
    $sp = $item.Split(' ')[0]
    $version = $item.Split(' ')[1]
    Write-Host "$($item) " -NoNewline
    
    if ($(az storage directory exists --name "$($sp)" --account-name $account_name --connection-string  $connection_String --share-name "$($share_name)"  | ConvertFrom-Json).exists) {
        if ($(az storage directory exists --name "$($sp)/$($version)" --account-name $account_name --connection-string  $connection_String --share-name "$($share_name)"  | ConvertFrom-Json).exists) {
            $status = "SP & Version found"
        }
        else {
            $status = "VersionNotFound"
        }
    }
    else {
        $Status = "ParentNotFound"
    }
    Write-Host $status
    Add-Content $report "$($item), $($status)"
}

