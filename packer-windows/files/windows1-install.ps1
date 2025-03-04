# $ErrorActionPreference = 'Stop'

# # Install Chocolatey
# # See https://chocolatey.org/install#individual
# Set-ExecutionPolicy Bypass -Scope Process -Force
# [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
# Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# # Globally Auto confirm every action
# # See: https://docs.chocolatey.org/en-us/faqs#why-do-i-have-to-confirm-packages-now-is-there-a-way-to-remove-this
# choco feature enable -n allowGlobalConfirmation

# # Install Chocolaty
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
# # Install Python
choco install -y python
refreshenv
# $env:Path += ";C:\Python36;C:\Python36\Scripts"     
# # Upgrade PIP
#python -m pip install --upgrade pip
# #python -V
# #pip -V
# # Install awscli
pip install awscli
aws --version
mkdir s3-local
cd s3-local
# # Copy all files from mys3packersrcbucket to cwd. 
# # AWS credentials are taken care of by the instance role
# # aws s3 cp s3://mupandopackerproject-bucket/packer/ ./ --recursive
dir
