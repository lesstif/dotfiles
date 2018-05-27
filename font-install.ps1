#  scoop install & config php 

## install php with suggest package
#
# . .\func1.ps1
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try {
    . ("$ScriptDirectory\func1.ps1")
    . ("$ScriptDirectory\Add-Font.ps1")
    . ("$ScriptDirectory\Remove-Font.ps1")
#    . ("$ScriptDirectory\FontHelper.ps1")
#    . ("$ScriptDirectory\YourFile3.ps1")
}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
}

$sourceCodePro = "https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip"
$firaCode = "https://github.com/tonsky/FiraCode/releases/download/1.205/FiraCode_1.205.zip"
$nanumCoding = "https://github.com/naver/nanumfont/releases/download/VER2.5/NanumGothicCoding-2.5.zip"

$folder = ".\font"

if((Test-Path $output) -eq 0)
{
	mkdir $folder
#	cd $output
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
##Foreach($url in ($sourceCodePro, $firaCode, $nanumCoding)) {
Foreach($url in ($sourceCodePro )) {
	Write-Host "Downloading font $f"

$req = [System.Net.HttpWebRequest]::Create($url)
$req.Method = "HEAD"
$response = $req.GetResponse()
$fUri = $response.ResponseUri
$filename = $download.headers["Content-Disposition"]
#[System.IO.Path]::GetFileName($fUri.LocalPath); 
$response.Close()
$target = join-path $folder $filename 

	Invoke-WebRequest -Uri $url -outFile $target
}
Process-FontInstall "font"

