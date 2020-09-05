#!/usr/bin/env bash
set -e
trap "exit" INT

function realpath() {
  echo "$(cd "$(dirname $1)" && pwd)/$(basename $1)"
}

TF_VERSION="${TF_VERSION:-13}"

terraform="$(realpath "./bin/terraform-$TF_VERSION")"

echo "Using Terraform $TF_VERSION binary at $terraform: $($terraform -v)"

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
    echo "🧹 Terraform: Clean cache"
    rm -rf ".terraform"
    echo "🧵 Terraform: Init"
    retry_with_log "$terraform" init -backend=false
    echo "🪁 Terraform: Validate"
    "$terraform" validate
  )
}

# Let's delay failure, so we could test all modules and fail after checking everything
failed=no

function cmd_validate() {
  local module=$1
  export VAULT_ADDR=https://example.com # Handle https://github.com/terraform-providers/terraform-provider-vault/issues/666
  local basepath="./modules/*"
  local target="all examples"
  if [[ -n "$module" ]]; then
    basepath="./modules/$module"
    target="module $module"
  fi
  echo "Running init and validate for $target..."
  for dir in $basepath/example/*/; do
    if [[ -d "$dir" ]]; then
      validate "$dir" || failed=yes
    fi
  done
  for example in $basepath/example/main.tf; do
    if [[ -f "$example" ]]; then
      validate "$(dirname "$example")" || failed=yes
    fi
  done
}

function cmd_format() {
  echo "Running format for all modules..."
  "$terraform" fmt -recursive ./modules
}

case "$1" in
validate)
  cmd_validate $2
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
