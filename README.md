# CSCI 104 Docker

This repository contains a Dockerfile and a couple of management scripts for creating and using a virtualized Linux container capable of building, running, and debugging C++.
Using a virtualized container is preferable to a user's local machine because it guarantees consistent compilation and execution of C++ binaries. 
While compilers and tooling may vary between systems, creating a sealed environment from the exact same components every time ensures that code runs the same for graders as it does students.  

But why use Docker over a traditional virtual machine?
Docker is considerably less resource-intensive than installing a full virtual machine.
Instead of needing the facilities for a graphical interface, virtual file system, etc., we can mount any directory of the host machine directly in the container and use a shell to run compilation and debugging.
Development and file management may be done normally on the local machine.

## Installing the Image

1. Install Docker desktop from [the website](https://www.docker.com/products/docker-desktop)
2. Install the `csci104` image from DockerHub or build it as described below

## Starting the Image

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

Thus, our complete command is:

```bash
docker run -v /Users/username/Documents/hw-username/:/work/ -dt --cap-add SYS_PTRACE --security-opt seccomp=unconfined csci104
```

Or, you can make a copy of the provided setup script, `setup.bat` for Windows and `setup.sh` for macOS, and fill in the path to your material folder.
After that, simply running that script in the command line will correctly run the Docker container.

**Note that you only need to run the Docker container once, as it will remain active in the background until you shut down your computer or manually stop it.**

## Accessing the Command Line

Finally, to access the command line of the container you've started, we want to use the `exec` command. 
We will add two options to make the command prompt usable:

- `-i` allows the `exec` to be interactive
- `-t` provides us access to an actual shell

Thus, the final command is:

```bash
docker exec -it containerid bash
```

## Stopping the Image

First, find the ID of the container you started by running `docker container ls`.
In case you are for any reason running other containers, make sure to locate the one with image `csci104`.

Now, simply run the Docker kill command with that ID:

```bash
docker kill containerid
```
