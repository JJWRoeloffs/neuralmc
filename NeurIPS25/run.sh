#!/usr/bin/env bash
set -xe
docker build --tag neuralinvariants .
docker run -it --rm -v ./NeurIPS-Artefact:/root/neuralmc/NeurIPS-Artefact neuralinvariants bash

