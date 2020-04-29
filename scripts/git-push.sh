#!/usr/bin/env bash
set -e

git add .
git commit -m "chore: format & readme update"
git push origin master --force
