#!/usr/bin/env bash

USAGE="
$0 e <plain content>
$0 d <encrypted content>
"

if [ -z $2 ]; then
  echo $USAGE
  exit 0
fi
verb=$1
content=$2

if [[ "$verb" = "d" ]]; then
  dash_d="-d"
elif [[ "$verb" = "e" ]]; then
  dash_d=""
else
  echo "Unrecognized command $verb"
  exit 1
fi

echo "Enter your password, or just press ENTER for base-64 encoding:"
read -s password


if [ $password ]; then
  [[ $dash_d ]] && echo "Decrypted content:" || echo "Encrypted content:"
  echo "$content" | openssl enc -aes-256-cbc -base64 $dash_d -pass pass:$password
else
  [[ $dash_d ]] && echo "Base64-decoded content:" || echo "Base64-encoded content:"
  echo "$content" | openssl enc -base64 $dash_d
fi