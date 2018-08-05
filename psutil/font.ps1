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
function notice {
    Write-Host $Argv[1] -Foreground Magenta
}

function install_global {
    Param($dir, $wildcard)
    $regist = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    Get-ChildItem $dir -Filter $wildcard | ForEach-Object {
        New-ItemProperty -Path $regist `
                         -Name $_.Name.Replace($_.Extension, ' (TrueType)')`
                         -Value $_.Name -Force `
            | Out-Null
        Copy-Item "$dir\$_" -Destination "$env:windir\Fonts"
    }
}
function uninstall_global {
    Param($dir, $wildcard)
    $regist = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
    Get-ChildItem $dir -Filter $wildcard | ForEach-Object {
        Remove-ItemProperty -Path $regist `
                            -Name $_.Name.Replace($_.Extension, ' (TrueType)') `
                            -ErrorAction SilentlyContinue
                            -Force
        Remove-Item "$env:windir\Fonts\$($_.Name)" -ErrorAction SilentlyContinue -Force
    }
}

function install_local {
    Param($dir, $wildcard)
    if (!(Test-Path $env:JP_FONT_DIR -ItemType Directory)) {
        New-Item -Path $env:JP_FONT_DIR -ItemType Directory -Force
    }
    Get-ChildItem $from -Filter $wildcard | ForEach-Object {
        Copy-Item "$dir\$_" -Destination $env:JP_FONT_DIR
    }
    notice "Font files are copied to '$env:JP_FONT_DIR'."
}
function uninstall_local {
    Param($dir, $wildcard)
    Get-ChildItem $dir -Filter $wildcard | ForEach-Object {
        Remove-Item "$env:JP_FONT_DIR\$($_.Name)" -ErrorAction SilentlyContinue -Force
    }
}

# main
if ($env:JP_FONT_DIR -eq "") {
    [environment]::SetEnvironmentVariable('JP_FONT_DIR', "$HOME\JpFonts", 'User')
}
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
