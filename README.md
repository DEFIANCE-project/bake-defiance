# Bake setup helper for ns-defiance

## Preparations

TL;DR: Start and build the devcontainer. If you are using vscode, see [here](https://code.visualstudio.com/docs/devcontainers/containers) for more information about developing in devcontainers.

### Docker

Otherwise, we support building ns3-definace as a docker container for the most seamless experience.

First, build the base image with `docker build . -f .devcontainer/Dockerfile -t defiance-devcontainer`.

Then, you can build the full image with `docker build -f Dockerfile-development`. The ns3 root directory is the default working directory and at `$NS3_HOME`. To build ns3 and ns3-defiance as well, you can add `--build-arg BUILD_NS3=True`.

For training e.g. in a cluster, it is convenient to have a small docker image with all requirements necessary for training. For this, there is `Dockerfile-train`. Once you have built a ns3-ai simulation, you can run `docker build -f Dockerfile-train` to build an image containing runtime dependencies only and all your built simulations. Inside it, you can start training on our examples right away with e.g. `run-agent train -n ./contrib/defiance/ns3.40-defiance-balance2`.

### Semi-automated

For a semi-automated install, there is a `Makefile`:

Clone the repository and run `make bootstrap`. Then, you can build ns3 with `bake` or the ns3 wrapper.

It can be nice to add the tools to your path and set some environment variables:

```shell
export BAKE_HOME="`pwd`/bake"
export PYTHONPATH="$PYTHONPATH":"$BAKE_HOME"
export SUMO_HOME="/usr/share/sumo"
export NS3_HOME="`pwd`/source/ns-3.40"
export PATH="$PATH":"$BAKE_HOME":"$NS3_HOME"
```

The `Makefile` assumes that all required dependencies are installed. Refer to [.devcontainer/Dockerfile](.devcontainer/Dockerfile) for a complete list of all development dependencies. If there are missing dependencies, `bake` will warn you about them when running `make bootstrap`.

What happens behind the curtain of `make download` and `make bootstrap`:

1. [`bake`](http://planete.inria.fr/software/bake/index.html) is added via a git submodule. So, clone this with the `--recursive` flag or run `git submodule update --init`.

1. A `bakefile.xml` is needed with the right configuration for ns3-defiance. To create it from bake, run

    ```bash
    bake.py configure -e ns-3.40 -e ns3-defiance -e ns3-ai -e ns3-5g-lena
    ```

1. Now you can download ns3 with its modules with `bake.py download`. Afterwards, `source/ns-3.40` contains the sources to build and run ns-defiance.

1. From this point on, ns3-ai is setup up and everything is being installed with its python dependencies:

    ```bash
    ns3 build ai
    cd contrib/defiance
    poetry install
    pip install -e ../ai/python_utils -e ../ai/model/gym-interface/py
    ```

1. If you have modified the `defiance.xml`, you need to use

    ```shell
    bake.py fix-config
    ```

   This is done automatically by `make bootstrap`.

1. Finally, you can build ns3 with `bake` or by using the ns3 wrapper.

## What are devcontainers?

To improve the developer experience we decided on using `Dev-Containers`. You may be familiar with Docker Containers: lightweight packages of software that contain everything to run your specific program. A `Dev-Container` furthermore includes all the tools necessary for you to develop the application. In order to use the `Dev-Container` you can open the project in `VS Code` and then use the option `Reopen in Container`.

### Git support

Git is supported inside the Dev-Container per default. As the repository itself lives inside the mounted `/code` directory you will have to change to this directory, before using your git commands. Otherwise you might try to push to the `ns3` repository unintentionally.
Note: Cou can open the repository in `VS Code` with `Strg+Shift+P -> Open Repository`. Now choose `/code`.

### Using the ns3 build system

As ns3 is mainly written in C++ you will have to compile your files before you can actually run your experiments. For this `cmake` is used by ns3.

Before building your source files you will have to configure them. You can do this inside the `/code/ns3` repository in the `Dev-Container` by executing `./ns3 configure`.
Afterwards you can build the entire project with `./ns3 build` or a specific `cmake`-target with `./ns3 build TARGET_NAME`.

Because ns3 uses `cmake`, every executable can simply be configured with an appropriate `CMakeLists.txt` entry. ns3 suggests using their custom macros for registering examples, tests and executables. Refer to the [docs](https://www.nsnam.org/docs/manual/html/working-with-cmake.html#executable-macros) for more information.

### CMake-Tools extension

Inside the `Dev-Container` the CMake-Extension is activated. You can use the extension to easily debug the specific target you are working on.

- `Strg+Shift+P` CMake: Set Build Target -> Specify the build target you want to run or debug.
- `Strg+Shift+P` CMake: Debug -> Debug the build target. This will automatically rebuild if you changed relevant files.

There are some pitfalls using the cmake extension: A complete rebuild is necessary, when cmake is reconfigured differently. This easily happens when mixing `ns3 configure` and cmake-tools. By default, configuring with cmake-tools is equivalent to `ns3 configure --enable-tests --enable-examples --enable-python -d debug`. Switching the build profile via cmake-tools is supported. Multiple build trees are not supported out of the box.
