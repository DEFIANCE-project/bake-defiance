FROM --platform=linux/amd64 ubuntu:jammy
WORKDIR /code

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Europe/Berlin

# Dependencies
ENV POETRY_VIRTUALENVS_IN_PROJECT true
RUN apt-get update && apt-get install -y build-essential ccache clang-format cmake default-jdk dia doxygen dvipng ffmpeg gdb git git-lfs graphviz imagemagick latexmk libboost-dev libboost-program-options-dev libc6-dev libeigen3-dev libfox-1.6-dev libgdal-dev libgl2ps-dev libproj-dev libprotobuf-dev libsqlite3-dev libxerces-c-dev make maven ninja-build protobuf-compiler pybind11-dev python3-dev python3-gi python3-jinja2 python3-opencv python3-pip python3-pygments python3-sphinx python3-venv python-is-python3 software-properties-common sqlite3 swig texlive texlive-base texlive-fonts-extra texlive-font-utils texlive-formats-extra texlive-science unzip
RUN pip install poetry cppyy==2.4.2

# setup docs creation
RUN sed -i "s/EPS,PDF,//g" /etc/ImageMagick-6/policy.xml
RUN sed -i "s/none/read\ |\ write/g" /etc/ImageMagick-6/policy.xml

# sumo
RUN add-apt-repository ppa:sumo/stable
RUN apt-get install -y sumo sumo-tools sumo-doc
ENV SUMO_HOME="/usr/share/sumo"
ENV NS3_HOME="/code/source/ns-3.40"

# bake helper
ENV PATH="/code/bake:$PATH"
# ns helper
ENV PATH="/code/source/ns-3.40:$PATH"
# defiance venv
ENV PATH="/code/source/ns-3.40/contrib/defiance/.venv/bin:$PATH"
# ccache
ENV CCACHE_SLOPPINESS=pch_defines,time_macros

RUN git config --global --add safe.directory /code
