import-module au

$downloadPage = 'https://cryptomator.org/downloads/#winDownload'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.url64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.url32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.checksum64)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.checksum32)'"
        }
     }
}

function global:au_GetLatest {
    $downloadPageContent = Invoke-WebRequest -Uri $downloadPage

    $fileName64 = 'Cryptomator-.*-x64.exe'
    $fileName32 = 'Cryptomator-.*-x86.exe'
    $url64      = $downloadPageContent.links | ? href -match $fileName64 | select -First 1 -expand href
    $url32      = $downloadPageContent.links | ? href -match $FileName32 | select -First 1 -expand href
    $version    = $url64 -split '-|.exe' | select -Last 1 -Skip 2

    $checksum64 = ''
    $checksum32 = ''

    $checksumType64 = 'sha256'
    $checksumType32 = 'sha256'

    return @{ url64 = $url64; url32 = $url32; version = $version; checksumType64 = $checksumType64; checksumType = $checksumType32 }
}

update -ChecksumFor all -NoCheckUrl