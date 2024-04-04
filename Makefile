SAM_ARTIFACT=lambda
# Define build directory and package directory using the SAM_ARTIFACT variable
BUILD_DIR = .aws-sam/build/$(SAM_ARTIFACT)
PACKAGE_DIR = .aws-sam/build
# Notes from template:
# () Each command in the makefile must be a single line, and each command is run in a separate shell. Newer versions
# of make (than we currently  have) support .ONESHELL where it will reuse the shell. Since we are getting a separate shell,
# if we're using venvs we need to re-source the activation each time.
# 
# () We need to upgrade pip because of a bug where Big Sur Macos reports a different major version for the OS, which makes the old
# pip not use the whl file and instead build from a tar which takes forever. Make sure this happens before installing the other deps
# 
# () Installing the requirements for the app and the tests are not strictly required, as tox will install them in its venv if they
# aren't already there. However, they are a convenience for developers so they can point their IDE at a complete venv.

# cleans the previous build
clean:
	@echo "Cleaning up..."
	@if exist .aws-sam (rmdir /s /q .aws-sam) else (echo ".aws-sam directory not found.")
# cleans the python virtual environment, not run regularly, but available in case needed during development
clean-all: clean
	@if exist .tox(rmdir /s /q .tox) else (echo ".tox directory not found.")

setup: 
	python -m venv venv && venv\Scripts\activate && python -m pip install --upgrade pip && python -m pip install -r requirements.txt -r build-requirements.txt -r tests/requirements.txt

local-setup:
	py -m pip install -r requirements.txt -r build-requirements.txt -r tests/requirements.txt

local-setup-mac:
	py -m pip install -r requirements.txt -r build-requirements.txt -r tests/requirements.txt

lint: 
	venv\Scripts\activate && flake8 . --exclude=legacyCode,venv --max-line-length=105

local-lint:
	py -m flake8 . --max-line-length=105 --exclude=legacyCode,venv,.tox,common

local-lint-mac:
	python -m flake8 . --max-line-length=105 --exclude=legacyCode,venv,.tox

local-test:
	py -m tox

local-test-mac:
	python -m tox

test: setup
	venv\Scripts\activate && tox


# Jenkins job: build -> package
#build: clean-all setup lint
#venv\Scripts\activate && sam build


# Create the Makefile
# Create a file called Makefile (no extension) in the root directory. This file will contain commands that can be run locally to automate dev/test workflows. In addition, this Makefile will be used during the Jenkins build pipeline. Specifically, the Jenkins pipeline will run make build followed by make package.
# Copy and paste the following code into your Makefile. 
# Make sure to update <SAM_ARFIFACT_NAME> with the same artifact name you used in the template.yaml file (CHOICE_IAM_<LAMBA_NAME>).
# Define targets
build:
	sam build --template template.yaml

package:
	sam build --template template.yaml --build-dir .aws-sam/build/$(SAM_ARTIFACT)
	sam package --template-file .aws-sam/build/$(SAM_ARTIFACT)/template.yaml --output-template-file packaged.yaml --s3-bucket samtestpoc

deploy:
	sam deploy --template-file packaged.yaml --stack-name my-stack-name --capabilities CAPABILITY_IAM
