FROM --platform=linux/amd64 ubuntu:jammy
WORKDIR /code

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Europe/Berlin

# Dependencies
ENV POETRY_VIRTUALENVS_IN_PROJECT true
RUN apt-get update && apt-get install -y build-essential cmake git python3-dev python3-pip python3-venv python3-opencv libboost-dev libboost-program-options-dev pybind11-dev libprotobuf-dev libxerces-c-dev libfox-1.6-dev libgdal-dev libproj-dev libgl2ps-dev python3-dev swig default-jdk maven libeigen3-dev protobuf-compiler python-is-python3 libc6-dev sqlite sqlite3 libsqlite3-dev gdb graphviz dia doxygen software-properties-common clang-format ffmpeg python3-gi unzip ninja-build ccache git-lfs
RUN pip install poetry cppyy==2.4.2

# sumo
RUN add-apt-repository ppa:sumo/stable
RUN apt-get install -y sumo sumo-tools sumo-doc
ENV SUMO_HOME="/usr/share/sumo"
ENV NS3_HOME="/code/source/ns-3.40"

# bake helper
ENV PATH="/code/bake:$PATH"
# ns helper
ENV PATH="/code/source/ns-3.40:$PATH"
# DEFIANCE venv
ENV PATH="/code/source/ns-3.40/contrib/DEFIANCE/.venv/bin:$PATH"

RUN git config --global --add safe.directory /code