# フォントのインストール/アンインストール用スクリプト
# 管理者権限の有無で以下のように処理内容を変化
# - 管理者: レジストリ登録
# - 非管理者: 専用ディレクトリへコピー
#
# 引数
#   1: インストールか否か($true or $false)
#   2: $dir(解凍したディレクトリへのパス)
#   3: フォント名を示すワイルドカード
#
# 環境変数
#   JP_FONT_DIR: ローカルインストール時に利用するディレクトリ
#                デフォルト値: "$HOME\JpFonts"

Param($is_install, $dir, $wildcard)

function is_admin {
    $admin = [security.principal.windowsbuiltinrole]::administrator
    $id = [security.principal.windowsidentity]::getcurrent()
    ([security.principal.windowsprincipal]($id)).isinrole($admin)
}
function warn {
    Param($msg)
    Write-Host "Warning: $msg" -ForegroundColor Red
}
function notice {
    Param($msg)
    Write-Host $msg -ForegroundColor Magenta
}
function log {
    Param($msg)
    Write-Host $msg -ForegroundColor White
}

function install_global {
    Param($dir, $wildcard)
    $regist = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    $postfix = ' (TrueType)'
    Get-ChildItem $dir -Filter $wildcard | ForEach-Object {
        log "registering $_ ..."
        New-ItemProperty -Path $regist `
                         -Name $_.Name.Replace($_.Extension, $postfix)`
                         -Value $_.Name -Force `
            | Out-Null
        Copy-Item "$dir\$_" -Destination "$env:windir\Fonts"
    }
}
function uninstall_global {
    Param($dir, $wildcard)
    $regist = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    $postfix = ' (TrueType)'
    Get-ChildItem $dir -Filter $wildcard | ForEach-Object {
        log "unregistering $_ ..."
        Remove-ItemProperty -Path $regist `
                            -Name $_.Name.Replace($_.Extension, $postfix) `
                            -ErrorAction SilentlyContinue
                            -Force
        Remove-Item "$env:windir\Fonts\$($_.Name)" -ErrorAction SilentlyContinue -Force
    }
}

function install_local {
    Param($dir, $wildcard)
    $pool = [environment]::GetEnvironmentVariable('JP_FONT_DIR', 'User')
    if ($pool -eq $null -or $pool -eq "") {
        $pool = "$HOME\JpFonts"
        [environment]::SetEnvironmentVariable('JP_FONT_DIR', "$HOME\JpFonts", 'User')
    }
    if (!(Test-Path $pool)) {
        notice "Make new directory '$pool' to access font files easily."
        New-Item -Path $pool -ItemType Directory -Force
    }
    Get-ChildItem $from -Filter $wildcard | ForEach-Object {
        log "making copy of $_ ..."
        Copy-Item "$dir\$_" -Destination $pool
    }
    notice "Font files are copied to '$pool'."
    notice "You can access this directory from THE NEXT SESSION with these commands:"
    notice '- cmd.exe     explorer %JP_FONT_DIR%'
    notice '- PowerShell  explorer $env:JP_FONT_DIR'
}
function uninstall_local {
    Param($dir, $wildcard)
    $pool = [environment]::GetEnvironmentVariable('JP_FONT_DIR', 'User')
    if ($pool -eq $null) {
        warn "%JP_FONT_DIR% is not defined. End uninstallation."
        return 1
    }
    if (!(Test-Path $pool)) {
        warn "%JP_FONT_DIR% is not existing directory. End uninstallation."
        return 2
    }
    Get-ChildItem $dir -Filter $wildcard | ForEach-Object {
        log "deleting copy of $_ ..."
        Remove-Item "$pool\$($_.Name)" -ErrorAction SilentlyContinue -Force
    }
}

# main
if (is_admin) {
    if ($is_install) {
        install_global   $dir $wildcard
    } else {
        uninstall_global $dir $wildcard
    }
} else {
    if ($is_install) {
        install_local    $dir $wildcard
    } else {
        uninstall_local  $dir $wildcard
    }
}
