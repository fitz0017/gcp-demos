#!/bin/bash

# Startup script for a Debian GCE instance for dev use with python3 installed.

sudo apt-get update 

sudo apt-get install git

sudo apt-get install python3-setuptools python3-dev build-essential

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

sudo python3 get-pip.py

# Install Python code samples

git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git 
