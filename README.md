# Overview
This repository is intended to be a simple solution for running FAUST locally without having to worry about set-up and configuration.

# Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [File Structure](#file-structure)
- [Building the Docker image locally](#building-the-docker-image-locally)
- [Usage](#usage)
- [Known Limitations](#known-limitations)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# File Structure

| Name | Type | Description |
|------|------|-------------|
| `input_files`  | Directory | This is where the flow workspace directory being analyzed should be placed |
| `output_files` | Directory | This is where the analysis output will be generated |
| `faust_configurations.yml` | File | This is the file that stores configurations for FAUST's execution |
| `faust_image.dockerfile` | File | This is the docker file that is used to build the docker image hosted on docker hub |
| `build_faust_docker_image.sh` | File | This is the file that will execute the build command for the FAUST docker image (It MUST be run from the repository root directory - `sh build_faust_docker_image.sh`) |
| `run_faust_docker.sh` | File | This is the file that will execute FAUST using the existing docker image (It MUST be run from the repository root directory - `sh run_faust_docker.sh`) |

# Configurations
1. [Install Docker](https://hub.docker.com/?overlay=onboarding)

That's it!

# Building the Docker image locally
From the root repository run the command
`sh build_faust_docker_image.sh`

# Usage
1. Delete all contents from the `input_files` directory
2. Copy a flow workspace directory into the `input_files` directory
    - Only one flow workspace directory can be used at a time
3. Set FAUST run-time configurations in the `faust_configurations.yaml`
    - These should specific to each user's specific analysis
4. Run Faust
    - `sh run_faust_docker.sh`
5. Wait for FAUST to complete
6. Retrieve analysis output from `output_files`

# Known Limitations
- This will take some time to run
- This does not scale well because it runs in a docker container
- This can only handle one workspace folder