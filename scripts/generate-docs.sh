#!/usr/bin/env bash
set -e

echo "Generating README files for all modules..."
for dir in ./modules/*; do
  echo "📝 $dir"
  ./bin/terraform-docs markdown "$dir" > "$dir/README.md"
done
