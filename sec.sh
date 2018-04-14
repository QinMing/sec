#!/usr/bin/env bash

USAGE="Usage: $0 [ e | d ] [-i <input_file>] [-o <output_file>]"

args=()

while [[ $1 ]] ; do
  case "$1" in
    -i )
      input_file=$2
      shift 2
      ;;
    -o )
      output_file=$2
      shift 2
      ;;
    -- )
      shift
      break
      ;;
    -* )
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
    * )
      args+=($1)
      shift 1
      ;;
  esac
done

verb=${args[0]}

if [[ "$verb" = "d" ]]; then
  dash_d="-d"
elif [[ "$verb" = "e" ]]; then
  dash_d=""
else
  echo "Unrecognized verb $verb"
  echo $USAGE
  exit 1
fi

echo "Enter your password. Leave empty for base-64 encoding:"
read -s password

if [[ $input_file ]]; then
  input_file_mixin="-in $input_file"
else
  input_file_mixin=""
  echo "Enter content, ending with EOF character (ctrl + d):"
fi

if [[ $output_file ]]; then
  output_file_mixin="-out $output_file"
else
  output_file_mixin=""
fi

if [[ $password ]]; then
  openssl enc -aes-256-cbc -base64 $dash_d -pass pass:$password $input_file_mixin $output_file_mixin
else
  openssl enc -base64 $dash_d $input_file_mixin $output_file_mixin
fi
