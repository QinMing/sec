#!/usr/bin/env bash

USAGE="
$0 [ e | d ]
"

if [[ -z $1 ]]; then
  echo $USAGE
  exit 0
fi
verb=$1

if [[ "$verb" = "d" ]]; then
  dash_d="-d"
elif [[ "$verb" = "e" ]]; then
  dash_d=""
else
  echo "Unrecognized command $verb"
  exit 1
fi

echo "Enter your password. Leave empty for base-64 encoding:"
read -s password

echo "Enter content, ending with EOF character (ctrl + d):"

if [[ $password ]]; then
  openssl enc -aes-256-cbc -base64 $dash_d -pass pass:$password
else
  openssl enc -base64 $dash_d
fi