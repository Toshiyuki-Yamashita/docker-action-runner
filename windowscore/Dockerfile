FROM mcr.microsoft.com/powershell:nanoserver-1903

WORKDIR $ProgramFiles/actions/actions-runner
COPY build.ps1 .
RUN pwsh.exe -File  build.ps1

COPY start.ps1 .

CMD [ "start.ps1"]