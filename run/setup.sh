#!/usr/bin/env sh
set -e

app_root=${1:-_build/orb-prod}
mkdir -p $app_root
script_path=${app_root}/deploy.sh
git_repo=cao7113/hello-phx

mkdir -p $app_root
# force clean old version
[ -f $script_path ] && rm -fr $script_path

script_url="https://raw.githubusercontent.com/${git_repo}/main/run/deploy.sh"
if [ ! -e $script_path ]; then
  wget -q -O $script_path $script_url
  chmod +x $script_path
  echo "Setup deploy-script into ${script_path} from ${script_url}"
else 
  echo "Use existed deploy-script: ${script_path}, manually delete it if need update!!"
fi

echo "## Deploy as following"
echo "$script_path v0.0.0 # $app_root bin/hello_phx cao7113/hello-phx 3"