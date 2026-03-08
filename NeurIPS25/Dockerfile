FROM ubuntu:24.04

# To prevent tzdata from prompting current location
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y python3 python3-pip python3-venv git software-properties-common wget vim pkg-config libgmp-dev build-essentials

COPY ./ebmc_5.6_amd64.deb ./root/
RUN dpkg -i ebmc_5.6_amd64.deb

RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/python3 -m pip install colorama numpy matplotlib cmake meson ninja cython

WORKDIR /root/neuralmc
