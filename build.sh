#!/usr/bin/env bash
set -eux

if [ -z ${1+x} ]; then
	echo Usage $0 1.1.1
	exit 1
fi

VERSION=$1

#It is shame that there is no better way to get sum :(
curl https://github.com/denoland/deno/releases/download/v${VERSION}/deno-x86_64-unknown-linux-gnu.zip -L --output /tmp/deno-x86_64-unknown-linux-gnu.zip
SHA=`sha256sum /tmp/deno-x86_64-unknown-linux-gnu.zip |awk '{ print $1 }'`

echo SHA256SUM ${SHA}

git checkout master
git pull origin master

git checkout -b v${VERSION}

sed Dockerfile -i -e "s/^ARG VERSION.*/ARG VERSION=${VERSION}/"
sed Dockerfile -i -e "s/^ARG SHA256SUM.*/ARG SHA256SUM=${SHA}/"

docker build -t samika/deno:${VERSION} .
docker run -it --rm samika/deno:${VERSION} run https://deno.land/std/examples/welcome.ts |grep "Welcome to Deno"

if [ $? == 1 ]; then 
	exit "Unable to run the container"
fi

git add Dockerfile
git commit -m "Update v${VERSION}"

