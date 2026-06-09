$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ProjectRoot

$env:JUPYTER_CONFIG_DIR = Join-Path $ProjectRoot ".jupyter"
$env:JUPYTER_RUNTIME_DIR = Join-Path $ProjectRoot ".jupyter\runtime"
$env:JUPYTER_DATA_DIR = Join-Path $ProjectRoot ".jupyter\data"

New-Item -ItemType Directory -Force -Path `
    $env:JUPYTER_CONFIG_DIR, `
    $env:JUPYTER_RUNTIME_DIR, `
    $env:JUPYTER_DATA_DIR | Out-Null

$LogPath = Join-Path $ProjectRoot "jupyter_server.log"
$CookieSecretFile = Join-Path $env:JUPYTER_RUNTIME_DIR "jupyter_cookie_secret_background"

& ".\.venv\Scripts\jupyter.exe" notebook "notebook/customer_sales_analysis.ipynb" `
    --no-browser `
    --ip=127.0.0.1 `
    --port=8888 `
    --port-retries=50 `
    --IdentityProvider.token=customer-sales-dashboard `
    "--ServerApp.cookie_secret_file=$CookieSecretFile" *>&1 | Tee-Object -FilePath $LogPath
