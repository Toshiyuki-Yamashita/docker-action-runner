FROM mcr.microsoft.com/powershell:nanoserver-1903

WORKDIR $ProgramFiles/actions

RUN mkdir actions-runner
RUN cd actions-runner
RUN pwsh.exe -Command Invoke-WebRequest -Uri https://githubassets.azureedge.net/runners/2.160.2/actions-runner-win-x64-2.160.2.zip -OutFile actions-runner-win-x64-2.160.2.zip
RUN pwsh.exe -Command Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.160.2.zip", "$PWD")

COPY ppwsh.exe -File start.ps1 

CMD [ "start.ps1"]