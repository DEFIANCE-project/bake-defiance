# build .devcontainer/Dockerfile first
ARG BASE=defiance-devcontainer  

FROM --platform=amd64 $BASE

COPY . .

RUN apt-get remove -y git-lfs && make bootstrap && apt-get install -y git-lfs

WORKDIR $NS3_HOME

# set to 'True' to build ns3 and ns3-defiance
ARG BUILD_NS3=

RUN if [ "$BUILD_NS3" = "True" ]; then ./ns3 build; fi
