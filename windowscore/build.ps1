
Param(
    [String]$Uri = "https://githubassets.azureedge.net/runners/2.160.2/actions-runner-win-x64-2.160.2.zip",
    [String]$ProxyServer = $Env:HTTP_PROXY
 )

if (-not $ProxyServer) {
    $params = @{}
} else {
    $params = @{ Proxy = new Uri($ProxyServer)}
}


Invoke-WebRequest @params -Uri https://githubassets.azureedge.net/runners/2.160.2/actions-runner-win-x64-2.160.2.zip -OutFile actions-runner-win-x64-2.160.2.zip
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.160.2.zip", "$PWD")
