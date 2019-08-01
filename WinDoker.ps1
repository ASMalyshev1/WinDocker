# Создание Docker образа Windows IIS
#https://hub.docker.com/_/microsoft-windows-servercore-iis
#https://www.geeklib.ru/admins/windows-server/2018/06/23/konvertirovanie-trialnoj-evaluation-versii-windows-server-2016-v-polnuju/

Clear-Host
Set-Location $PSScriptRoot

#.gitignore
"Docker.exe"|Out-File -FilePath .\.gitignore -Encoding utf8 -Force

function DockerInstall {

    IF (!(Get-Service|Where-Object {$_.Name -match "docker"})){

        Invoke-WebRequest -Uri https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe -OutFile .\Docker.exe
        Start-Process .\Docker.exe -Wait
        docker --version

    } ELSE {

        "Docker already installed"

    }

    #Remove .\Docker.exe
    IF (Test-Path -Path .\Docker.exe){
        
        Remove-Item -Path .\Docker.exe -Force

    }
}
DockerInstall

Invoke-WebRequest -Uri https://raw.githubusercontent.com/microsoft/iis-docker/master/windowsservercore-1903/Dockerfile -Method Get -OutFile .\Dockerfile -

# Docker
docker build -t iis-site .
docker run -d -p 8000:80 --name my-running-site iis-site
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" my-running-site