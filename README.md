# CSCI 104 Docker

This repository contains a Dockerfile and a couple of management scripts for creating and using a virtualized Linux container capable of building, running, and debugging C++.
Using a virtualized container is preferable to a user's local machine because it guarantees consistent compilation and execution of C++ binaries.
While compilers and tooling may vary between systems, creating a sealed environment from the exact same components every time ensures that code runs the same for graders as it does students.

But why use Docker over a traditional virtual machine?
Docker is considerably less resource-intensive than installing a full virtual machine.
Instead of needing the facilities for a graphical interface, virtual file system, etc., we can mount any directory of the host machine directly in the container and use a shell to run compilation and debugging.
Development and file management may be done normally on the local machine.

## Setup

First, **install Docker** desktop from [the website](https://www.docker.com/products/docker-desktop).
Once done, **clone this repository**, which contains a setup script for both Windows- and Unix-based systems.
Running it will build the the CSCI 104 docker image and produce a management command line executable.
On macOS in Terminal, run the respective setup script:

```bash
./unix/setup.sh
```

On Windows in CMD, the process is similar:

```cmd
.\windows\setup
```

When prompted, provide the directory in your local machine you wish to be accessible from the virtual machine.
For example, if you cloned your homework directory to `/Users/username/Documents/hw-username` or `C:\Users\username\Documents\hw-username`, enter that.
A management script should appear in the root directory of this repository.

## Manage

The `manage` script provides three commands.
To run it, you must be in the root directory of this repository.
Use the following command on macOS:

```bash
./manage.sh command
```

And on Windows:

```cmd
.\manage command
```

There are three commands you can run through the manage script.
- The first, `start`, starts the container up in the background.
  The container should continue running until you shut down your computer, exit docker, or kill the container manually.
- Next is `shell`, which simply opens a shell inside the virtual machine.
  This is where you can run standard linux commands, such as `g++` or `valgrind`.
- The last is `stop`, which manually shuts down the virtual container.

## Usage

The way we've set up Docker allows you to access all the files inside the directory you mounted to the container within the Linux environment from `/work`.
Changes you make will be immediately reflected in and outside of the virtual machine.
We **strongly recommend that you edit your code outside of the container and then compile and debug it inside the shell**.

Generally, **we also recommend that you `start` the container once and leave it running in the background** so that you can open a shell (using `./manage shell` or `.\manage shell`) whenever needed.
While not in use it will incur minimal resource usage.
Additionally, `stop`ping the image will completely erase any files in the container that are not under `/work`.

For example, say you run through the setup and mount the directory `/Users/me/Documents/cs104/`.
Next, you create a file `test.cpp` with some C++ code and put it in that directory.

```bash
~ $ cd /Users/me/Documents/cs104
~/Documents/cs104 $ touch test.cpp
```

You can edit the file from your computer's main operating system, then do the following to compile it:

```bash
~/Documents/cs104 $ cd /Path/To/docker
/Path/To/docker $ ./manage.sh shell          # On your computer, open a shell in the container
root@docker:/work $ g++ test.cpp -o test  # In the virtual machine compile test.cpp
root@docker:/work $ ./test                # Run the binary
```

You'll notice that the path you mounted always corresponds to `/work` inside the container.
No matter where you set the mount point to in your file system, this is where it'll be accessible.

## Details

**Note: everything you need is provided above.**
The `manage` script should handle standard use-scenarios for the docker environment.
However, if you're looking to fix issues you're having with the system or are interested in how it works, the following sections provide a thorough explanation of the three main commands used to manage the container.

### Starting the Image

Before we actually run a container with our image, we need to know where to mount the course material folder from.
Locate wherever you cloned it to on your computer and get the full path.
For example, on Windows that path might look like `C:\Users\username\Documents\hw-username\`, and on macOS it might look like `/Users/username/Documents/hw-username`.

The base command for running an image is:

```bash
# Don't run this yet
docker run image
```

However, there are several configurations we want to include:

- `-v /path/to/material/:/work/` mounts the work folder on our machine to `/work` in the container
- `-d` runs the container in the background
- `-t` allocates a command prompt for us to access when we interact with the container
- `--cap-add SYS_PTRACE` will allow GDB to correctly access executable runtimes
- `--security-opt seccomp=unconfined` allows memory allocation and debugging to work correctly
- `--name csci104` gives the container a name to reference in other docker commands

Thus, our complete command is:

```bash
docker run -v /Users/username/Documents/hw-username/:/work/ -dt --cap-add SYS_PTRACE --security-opt seccomp=unconfined --name csci104 csci104
```

Or, you can make a copy of the provided setup script, `setup.bat` for Windows and `setup.sh` for macOS, and fill in the path to your material folder.
After that, simply running that script in the command line will correctly run the Docker container.

**Note that you only need to run the Docker container once, as it will remain active in the background until you shut down your computer or manually stop it.**

### Accessing the Command Line

Finally, to access the command line of the container you've started, we want to use the `exec` command.
We will add two options to make the command prompt usable:

- `-i` allows the `exec` to be interactive
- `-t` provides us access to an actual shell

Thus, the final command is:

```bash
docker exec -it csci104 bash
```

### Stopping the Image

First, find the ID of the container you started by running `docker container ls`.
In case you are for any reason running other containers, make sure to locate the one with image `csci104`.

Now, simply run the Docker kill command with that ID:

```bash
docker kill containerid
```

Or, if you ran the image with the `--name` flag, you can use its name:

```bash
docker kill csci104
```

### Appendix: Valgrind Suppression

To determine the correct valgrind suppression in the future, refer to [this manual](https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howtohttps://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto).
Running it on a sufficiently complex piece of leak-free code will yield most of the necessary configurations.

### Note: Hypervisor on Windows

If you plan to using Docker and Virtual Box as a fallback, please be aware of what you will need to do to switch between the two systems. You'll have to toggle the Hypervisor:

Docker: Hypervisor **ON**

VirtualBox: Hypervisor **OFF**

Here's how you can do that on Windows:

1. Press Windows key + X and select `Apps and Features`.
2. Scroll down to the bottom and click Programs and Features link.
3. Then click the Turn Windows Hypervisor on or off link on the left pane.

This issue **ONLY** concerns Windows users.
