#!/usr/bin/env bash
set -xe
docker build --tag neuralmc .
docker run -it --rm -v ./NeurIPS-Artefact:/root/neuralmc/NeurIPS-Artefact neuralmc bash
