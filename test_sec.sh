#!/usr/bin/env bash
sec=./sec.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
DEFAULT_COLOR='\033[0m'
function test_case {
  echo -e "${BLUE}$1${DEFAULT_COLOR}"
}
function report_failure {
  echo -e "${RED}$1${DEFAULT_COLOR}"
}
function report_success {
  echo -e "${GREEN}$1${DEFAULT_COLOR}"
}

test_case "Test file in file out"

echo "some plain text" > input.txt
echo the_password | ./sec.sh e -i input.txt -o output.txt || exit 1
echo the_password | ./sec.sh d -i output.txt -o input_recover.txt || exit 1

actual_value=$(cat input_recover.txt)
if [[ "$actual_value" = 'some plain text' ]] ; then
  report_success "Pass"
else
  report_failure "Results are different"
  echo "some plain text"
  echo $actual_value
  exit 1
fi
rm input.txt || exit 1
rm output.txt || exit 1
rm input_recover.txt || exit 1

test_case "Test wrong password"

echo "some plain text" > input.txt
echo the_password | ./sec.sh e -i input.txt -o output.txt || exit 1
failed=false
echo another_password | ./sec.sh d -i output.txt -o input_recover.txt || failed=true
if [[ "$failed" = 'true' ]]; then
  report_success "Pass"
else
  report_failure "Password is wrong but didn't fail"
  exit 1
fi
rm -f input.txt
rm -f output.txt
rm -f input_recover.txt
