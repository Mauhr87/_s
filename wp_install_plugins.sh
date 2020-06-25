#/bin/bash

plugins_file="wp-plugins.json"

function get_public_plugins {
  for i in $(cat "../$1" | \
  jq ".public" | \
  grep \" | \
  sed 's/[\"|,|\ ]//g' | \
  sed 's/\:/\./' | \
  sed 's/$/.zip/' | \
  sed 's/^/https\:\/\/downloads\.wordpress\.org\/plugin\//' | \
  sed 's/\.latest//')
  do
   curl -sS "$i" > file.zip && unzip file.zip
   rm -rf file.zip
   echo "Downloading: " $i
  done
  }

# function get_premium_plugins {
#   for i in $(cat "../$1" | \
#   jq ".premium" | \
#   grep \" | \
#   sed 's/[\"|,|\ ]//g' | \
#   sed 's/\:/\./' | \
#   sed 's/$/.zip/' | \
#   sed 's/^/https\:\/\/api\.github\.com\/repos\/{username}\/{repo name}\/contents\//' | \
#   sed 's/\.latest//')
#   do
#     curl -H 'Authorization: token {your auth token}' -H 'Accept: application/vnd.github.v3.raw' -O -L $i
#     unzip *.zip
#     rm -rf *.zip
#     echo "Downloading: " $i
#   done
#   }

mkdir plugins

cd plugins

# get_premium_plugins $plugins_file
get_public_plugins $plugins_file

rm -rf ../../../plugins

cd ..

mv plugins ../../plugins

wp plugin activate --all

