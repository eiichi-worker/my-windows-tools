# UTF-8にする
# chcp 65001

# 引数定義
Param(
    [parameter(mandatory=$true)][string]$path
    ,[parameter(mandatory=$true)][string]$wallet
)
# TODO Pathの末尾の\を削除する

# 一時ダウンロード先
$tempPath = $Env:Temp + "\tmp_setup_ethminer\"
# ダウンロード先
$urlEthminer = "https://github.com/ethereum-mining/ethminer/releases/download/v0.10.0/ethminer-0.10.0-Windows.zip"
$urlEthProxy = "https://github.com/Atrides/eth-proxy/releases/download/0.0.5/eth-proxy-win.zip"
$urlRunEthminerBatTemplate = "https://raw.githubusercontent.com/eiichi-worker/my-windows-tools/master/Windows10/General/ethminer/template_run_ethminer.bat"
$urlEthproxyConfTemplate = "https://raw.githubusercontent.com/eiichi-worker/my-windows-tools/master/Windows10/General/ethminer/template_eth-proxy.conf"

# インストール先
$mainFolder = "$path\ethminer"
$ethminerFolder = "ethminer-0.10.0"
$ethproxyFolder = "eth-proxy-0.0.5"

Write-Output "Path: $path"
Write-Output "TempPath: $tempPath"
Write-Output "インストール先: $mainFolder\"

# インストール先フォルダ作成（すでにあったら諦める）
if (Test-Path "$mainFolder\") {
    Write-Output "Error インストール先がすでに存在します。: $mainFolder\"
    exit 1
}
New-Item -Path "$mainFolder\" -ItemType directory

# 一時フォルダを作成（すでにあったら消す）
if (Test-Path  $tempPath) {
    Remove-Item -path $tempPath -recurse -force
}
New-Item -Path $tempPath -ItemType directory

# ethminerをダウンロード
Write-Output "ethminerをダウンロードします... URL=$urlEthminer"
Invoke-WebRequest -Uri $urlEthminer -OutFile "$tempPath\ethminer.zip"
Write-Output "ethminerをダウンロードしました。"

# eth-proxyをダウンロード
Write-Output "eth-proxyをダウンロードします... URL=$urlEthProxy"
Invoke-WebRequest -Uri $urlEthProxy -OutFile "$tempPath\eth-proxy.zip"
Write-Output "eth-proxyをダウンロードしました。"

# 設定ファイルとかをダウンロード
Write-Output "設定ファイルのテンプレートをダウンロードします... URL=$urlEthProxy"
Invoke-WebRequest -Uri $urlRunEthminerBatTemplate -OutFile "$tempPath\template_run_ethminer.bat"
Invoke-WebRequest -Uri $urlEthproxyConfTemplate -OutFile "$tempPath\template_eth-proxy.conf"
Write-Output "設定ファイルのテンプレートをダウンロードしました。"

Write-Output "解凍します"
Expand-Archive -Path "$tempPath\ethminer.zip" -DestinationPath "$mainFolder\$ethminerFolder"
Expand-Archive -Path "$tempPath\eth-proxy.zip" -DestinationPath "$mainFolder\$ethproxyFolder"
Write-Output "解凍しました"

# 起動用バッチ作成
$batText = $(Get-Content "$tempPath\template_run_ethminer.bat")
$batText > "$mainFolder\$ethminerFolder\bin\run.bat"

# eth-proxyのコンフィグ設置
$file_contents = $(Get-Content "$tempPath\template_eth-proxy.conf") -replace "__________YOU_ARE_WALLET__________", $wallet
$file_contents > "$mainFolder\$ethproxyFolder\eth-proxy\eth-proxy.conf"