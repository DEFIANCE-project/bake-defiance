# Bake setup helper for ns-DEFIANCE

## Preparations

TL;DR: Start and build the devcontainer.

What happens behind the curtain of `make download` and `make bootstrap`:

1. [`bake`](http://planete.inria.fr/software/bake/index.html) is added via a git submodule. So, clone this with the `--recursive` flag or run `git submodule update --init`.

1. For local development, it can be nice to add `bake.py` to path:

    ```shell
    export BAKE_HOME=`pwd`/bake
    export PATH="$PATH":"$BAKE_HOME"
    export PYTHONPATH="$PYTHONPATH":"$BAKE_HOME"
    ```

    The following steps assume `bake.py` is accessible on the path

1. A `bakefile.xml` is needed with the right configuration for ns-DEFIANCE. To create it from bake, run

    ```bash
    bake.py configure -e ns-3.40 -e ns3-DEFIANCE -e ns3-ai -e ns3-5g-lena
    ```

1. Now you can download the ns3 with its modules with `bake.py download`. Afterwards, <source/ns-3.40> contains the sources to build and run ns-DEFIANCE.

1. From this point on, you can setup ns3-ai and install the python dependencies:

    ```bash
    ns3 build ai
    cd contrib/DEFIANCE
    poetry install
    pip install -e ../ai/python_utils && pip install -e ../ai/model/gym-interface/py
    ```

1. If you have modified the `defiance.xml`, you need to use

    ```shell
    bake.py fix-config
    ```

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
