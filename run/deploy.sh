#! /usr/bin/env sh
set -e

if [ $# -lt 1 ]; then 
  cat <<EOF
Usage:
  $0 VSN # BIN_PATH GIT_REPO KEEP_LIMIT"
  eg. ~/hello-phx/deploy.sh v0.1.0 # bin/hello_phx cao7113/hello-phx 3
EOF
  exit 1
fi

vsn=$1
bin_path=${2:-bin/hello_phx}
git_repo=${3:-cao7113/hello-phx}
keep_limit=${4:-3}

app_root=$(realpath $(dirname $0))
bin_name=$(basename $bin_path)
bare_vsn=$(echo $vsn | sed 's/^v//')
vsn_dir=${app_root}/$vsn
echo "Preparing deploy $vsn into dir: $vsn_dir"

if [ ! -d $vsn_dir ]; then 
  vsn_url=https://github.com/${git_repo}/releases/download/${vsn}/${bin_name}-${bare_vsn}.tar.gz 
  echo "Download $vsn app from url: $vsn_url"
  mkdir -p $vsn_dir
  tarfile=${app_root}/${vsn}.tar.gz
  wget -q -O $tarfile $vsn_url 
  tar -C $vsn_dir -xzf $tarfile
else 
  echo "Found existed app version: $vsn_dir, use it"
fi

cur_rel=$app_root/current
full_bin=$cur_rel/$bin_path

if [ -e $cur_rel ]; then
  if $full_bin pid; then
    echo "Try stop old process in current -> $(readlink -f $cur_rel)"
    $full_bin stop
    echo "Stop old process in $cur_rel if need at $(date -Iseconds)"
  fi

  rm -f $cur_rel
  echo "Clean old release link from current -> $(readlink -f $cur_rel)"
fi

echo Link new current-release to $vsn_dir
ln -sf $vsn_dir $cur_rel
echo "==> app bin-path: $full_bin"

env_file=$app_root/.env.prod
if [ -f $env_file ]; then
  echo "load env file: $env_file"
  . $env_file
fi
echo Starting app at $(date -Iseconds)
$full_bin daemon_iex

echo Waiting new app ready...
timeout=60
limit=$(( $timeout + 1 ))
for i in $(seq 1 $limit); do
  # echo waiting $i
  if [ $i -gt $timeout ]; then 
    echo "Waiting timeout, more than $timeout seconds at $(date -Iseconds)"
    exit 1
  fi

  $full_bin pid &>/dev/null
  if [ $? -eq 0 ]; then
    echo "New release=${vsn} come alive at $(date -Iseconds)"
    sleep 1
    break
  else
    echo Waiting pid alive at $(date -Iseconds)
    sleep 1
  fi
done
echo "Congrats! Deployed app to ${vsn_dir} at $(date -Iseconds)"
echo
echo "Try visit at http://ubox1.orb.local:4000"

## clean old versions
cd $app_root
total=$(find . -maxdepth 1 -mindepth 1 -type f -name "v*.tar.gz" | wc -l)
if [ $total -gt $keep_limit ]; then 
  old_num=$(( $total - $keep_limit ))
  for vsn in $(find . -maxdepth 1 -mindepth 1 -type f -name "v*.tar.gz" | sed 's/.*\///; s/\.tar\.gz//' | sort -V | head -n $old_num ) ; do 
    echo Cleaning old-version: $vsn
    rm -fr $app_root/$vsn
    rm -fr $app_root/$vsn.tar.gz
  done
fi
echo Kept at most ${keep_limit} from total $total versions in app_root=$app_root