#!/usr/bin/env bash
set -e

git add .
git commit --allow-empty -m "chore: automatic code formatting & readme update"
git push origin master --force
