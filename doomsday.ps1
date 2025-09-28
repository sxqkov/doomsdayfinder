Write-Host -ForegroundColor White "forked by sxqk"
$extensions = "*.jar"
$strings = @( 
"5OFV7PFTIMB0V"
)

$path = "C:\Users"

$i = 0
$total = (Get-ChildItem -Path $path -Include $extensions -Recurse -File).Count
Write-Progress -Activity "Expanding subdirectories..." -Status "Analyzing" -PercentComplete 0


$ErrorActionPreference = 'SilentlyContinue'

$results = @()

Get-ChildItem -Path $path -Include $extensions -Recurse -File | 
ForEach-Object { 
    $file = $_
    $content = Get-Content $file.FullName -Raw
    foreach($string in $strings){
        if($content.Contains($string)){
            $result = [PSCustomObject]@{
                FileName = $file.FullName
                StringMatched = $string
            }
            $results += $result
        }
    }
    $i++
    Write-Progress -Activity "Searching for files" -Status "Processing" -PercentComplete (($i/$total)*100)
}


$ErrorActionPreference = 'Continue'


if ($results.Count -gt 0) {
    Write-Host "FOUND MATCHES:" -ForegroundColor Yellow
    
    foreach ($result in $results) {
        Write-Host "PATH: " -NoNewline -ForegroundColor Red
        Write-Host $result.FileName -ForegroundColor White
        Write-Host "MATCH: " -NoNewline -ForegroundColor Yellow
        Write-Host $result.StringMatched -ForegroundColor White
    }
    
    Write-Host "`nmatches found: $($results.Count)" -ForegroundColor Green
} else {
    Write-Host "`nno matches found." -ForegroundColor Gray
}
