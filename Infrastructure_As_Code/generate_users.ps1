$filename = Read-Host "Output file name for test users"
Add-Content -Path $filename -Value "username.group"

$num_users = Read-Host "Number of test users to generate"
Write-Host $num_users Entered

$groups = Read-Host "Number of groups to randomly assign"
$groupArray = $groups -split ","


for($i=1; $i -le $num_users; $i++)
{
    $out = "user{0},{1}" -f $i,($groupArray | Get-Random)
    Write-Host $out
    Add-Content -Path $filename -Value $out
}