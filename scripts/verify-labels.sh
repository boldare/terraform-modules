#!/usr/bin/env bash

issue_url=$(echo "$github" | jq -r '.event.pull_request.issue_url')

# Note: We don't pass Github Token as a header here - this will work only for public repos
echo "Fetching labels for this issue..."
response=$(curl -sX GET "$issue_url/labels")

echo "Checking labels..."
label_count=$(echo "$response" | jq -r '[.[] | .name | select(. == "minor" or . == "major" or . == "patch")] | length')

if [[ $label_count -eq 1 ]]; then
  echo "Found exactly one of desired labels. 👍"
else
  echo "Please set exactly one of the following labels: major, minor, patch."
  echo "This is required for releasing a new version automatically."
  exit 1
fi
