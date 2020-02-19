#!/usr/bin/env bash
set -e

echo "Creating virtual environment..."
python3 -m venv python
source python/bin/activate
echo "Installing dependencies..."
pip install -r requirements.txt
deactivate

echo "Packaging dependencies..."
TARGET_ZIP=requirements.zip
zip -r9 "${TARGET_ZIP}" "./python/lib/python3.7/site-packages"

echo "Removing virtual environment..."
rm -rf ./python
