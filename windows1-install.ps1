# Install Chocolaty
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
# Install Python
choco install -y python
refreshenv
$env:Path += ";C:\Python36;C:\Python36\Scripts"
# Upgrade PIP
#python -m pip install --upgrade pip
#python -V
#pip -V
# Install awscli
pip install awscli
#aws --version
mkdir s3-local
cd s3-local
# Copy all files from mys3packersrcbucket to cwd. 
# AWS credentials are taken care of by the instance role
aws s3 cp s3://corighose-iac/packer/ ./ --recursive
dir
