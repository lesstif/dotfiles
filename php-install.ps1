#  scoop install & config php 

## install php with suggest package
scoop install php56 extras/vcredist2012
scoop install php70 extras/vcredist2015
scoop install php71 extras/vcredist2017

## current php 7.2
scoop install php extras/vcredist2017 composer

## x-debug Debugger:
# scoop install php-xdebug

## generate Custom php config file
## See https://github.com/lukesampson/scoop/wiki/Custom-PHP-configuration
#

foreach ($v in ("php56", "php70", "php71", "php")) {
    $persistDir = "$env:Userprofile/scoop/persist/$v"

    ## copy ini whether directory exist
    If((test-path $persistDir)) {
    
        $iniDIR = "$env:Userprofile/scoop/persist/$v/cli/conf.d"
        
        Write-Host "Copy ini file into $iniDir"
        Copy-Item -Path ./php/*ini -Destination $iniDIR
    }
}
