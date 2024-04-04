# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Quick summary
* Version
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Summary of set up
* Configuration
* Dependencies
* Database configuration
* How to run tests
* Deployment instructions

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact

#### Makefile commands explanation:
* Below is an explanation for each Makefile command:

* clean: Cleans the previous build by removing any generated build artifacts.

* clean-all: Scrubs the build environment, clearing any virtual environment ortox files along with the generated build artifacts.

* setup: Runs during the build pipeline, installs necessary requirements from the requirements.txt, build-requirements.txt and tests/requirements.txt files.

* local-setup: Run setup locally.

* local-setup-mac: setup locally (mac).

* lint: Runs during the build pipeline, runs a linter to check for formatting and best practice errors. 

* local-lint: Run lint locally.

* local-lint-mac: Run lint locally (mac).

* test: Runs during the build pipeline, runs all tox tests to validate functionality.

* local-test: Run tox tests locally.

* local-test-mac: Run tox tests locally (mac).

* build: The first make command run by the Jenkins pipeline. First, this command runs the preliminary make commands of clean-all, setup, lint, and test to prep the environment and check for errors. Then, sam build is run to create the build artifact.

* package: The second make command run by the Jenkins pipeline. This command grabs the artifact built by SAM and creates a lambda.zip file in the root directory. Note that this command will fail if the SAM_ARTIFACT specified at the top of the file does not match the value in the template.yaml file.