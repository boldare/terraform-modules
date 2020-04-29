#!/usr/bin/env bash
set -e

function realpath() {
  echo "$(cd "$(dirname $1)" && pwd)/$(basename $1)"
}

terraform="$(realpath ./bin/terraform)"

echo "Using Terraform binary at $terraform: $(terraform -v)"

function retry_with_log() {
  $@ &>/dev/null || $@
}

function validate() {
  local dir=$1
  echo "---------------------"
  echo "🔍 VALIDATING $dir"
  echo "---------------------"
  (
    cd "$dir"
    echo "🧵 Terraform: Init"
    retry_with_log "$terraform" init -backend=false
    echo "🪁 Terraform: Validate"
    "$terraform" validate
  )
}

# Let's delay failure, so we could test all modules and fail after checking everything
failed=no

function cmd_validate() {
  echo "Running init and validate for all examples..."
  for dir in ./modules/*/example/*/; do
    validate "$dir" || failed=yes
  done
  for example in ./modules/*/example/main.tf; do
    validate "$(dirname "$example")" || failed=yes
  done
}

function cmd_format() {
  echo "Running format for all modules..."
  "$terraform" fmt -recursive ./modules
}

case "$1" in
validate)
  cmd_validate
  ;;
format)
  cmd_format
  ;;
*)
  echo "No command specified. Use: validate|format"
  ;;
esac

if [[ "$failed" == "yes" ]]; then
  exit 1
fi
