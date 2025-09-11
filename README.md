# Bake setup helper for ns-defiance

## Preparations

TL;DR: Start and build the devcontainer. If you are using vscode, see [here](https://code.visualstudio.com/docs/devcontainers/containers) for more information about developing in devcontainers.

### Docker

Otherwise, we support building ns3-definace as a docker image for the most seamless experience.

First, build the base image with `docker build . -f .devcontainer/Dockerfile` which only contains development dependencies.
A prebuilt image is available at ghcr.io/defiance-project/bake-defiance:latest.

Then, you can build the full image with `docker build -f Dockerfile-development`. The ns3 root directory is the default working directory and at `$NS3_HOME`. To build ns3 and ns3-defiance as well, you can add `--build-arg BUILD_NS3=True`.
i

### Semi-automated

For a semi-automated install, there is a `Makefile`:

Clone the repository and run `make bootstrap`. Then, you can build ns3 with the ns3 wrapper in the `ns-3` submodule.

It can be nice to add the tools to your path and set some environment variables:

```shell
export SUMO_HOME="/usr/share/sumo"
export NS3_HOME="`pwd`/ns-3"
export PATH="$PATH":"$NS3_HOME"
```

The `Makefile` assumes that all required dependencies are installed. Refer to [.devcontainer/Dockerfile](.devcontainer/Dockerfile) for a complete list of all development dependencies. If there are missing dependencies, downstream tasks may fail.

What happens behind the curtain of `make download` and `make bootstrap`:

1. [`ns3-DEFIANCE`](https://github.com/DEFIANCE-project/ns3-DEFIANCE), [`ns3-ai`](https://github.com/DEFIANCE-project/ns3-ai) [`ns-3`](https://gitlab.com/nsnam/ns-3-dev/)  is added via a git submodule. So, clone this with the `--recursive` flag or run `git submodule update --init`.

1. The `defiance` and `ai` modules need to be placed into `ns-3/contrib`. This is atchieved by creating `git worktree`s there.

1. From this point on, ns3-ai is setup up and everything is being installed with its python dependencies:

    ```bash
    poetry -C contrib/defiance install --without local
    ns3 build ai
    poetry -C contrib/defiance install --with local
    ```

1. Finally, you can build ns3 with the wrapper.

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
