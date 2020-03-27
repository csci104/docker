# CSCI 104 Docker

This repository contains a Dockerfile and a couple of management scripts for creating and using a virtualized Linux container capable of building, running, and debugging C++.
Using a virtualized container is preferable to a user's local machine because it guarantees consistent compilation and execution of C++ binaries.
While compilers and tooling may vary between systems, creating a sealed environment from the exact same components every time ensures that code runs the same for graders as it does students.

But why use Docker over a traditional virtual machine?
Docker is considerably less resource-intensive than installing a full virtual machine.
Instead of needing the facilities for a graphical interface, virtual file system, etc., we can mount any directory of the host machine directly in the container and use a shell to run compilation and debugging.
Development and file management may be done normally on the local machine.

The rest of this README is a quickstart for more experienced users.
Feel free to read through the [wiki](https://github.com/csci104/docker/wiki) for **a more in-depth guide on [how setup and use Docker](https://github.com/csci104/docker/wiki/Usage)** as well as [how it works](https://github.com/csci104/docker/wiki/Details).

## System Requirements

Below are the system requirements for Docker Desktop:

[Windows host](https://docs.docker.com/docker-for-windows/install/):

- Windows 10 64-bit: Pro, Enterprise, or Education (Build 15063 or later).
- Hyper-V and Containers Windows features must be enabled.

If you are using Windows 10 Home, you can obtain a "free" license for Windows 10 Education [here](https://viterbiit.usc.edu/services/hardware-software/microsoft-imagine-downloads/).

[Mac host](https://docs.docker.com/docker-for-mac/install/):

- Mac hardware must be a 2010 or newer model
- macOS must be version 10.13 or newer
- 4 GB RAM minimum


## Setup

First, **install Docker** desktop from [the website](https://www.docker.com/products/docker-desktop).
Once done, **clone this repository**, which contains a setup script for both Windows- and Unix-based systems.
Running it will build the CSCI 104 docker image and produce a management command line executable.
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

**NOTE**: Please make sure you run the manage script from `Command Prompt`, and **NOT** `PowerShell`.

```cmd
.\manage command
```

There are three commands you can run through the manage script.
- The first, `start`, starts the container up in the background.
  The container should continue running until you shut down your computer, exit docker, or kill the container manually.
- Next is `shell`, which simply opens a shell inside the virtual machine.
  This is where you can run standard linux commands, such as `g++` or `valgrind`.
- The last is `stop`, which manually shuts down the virtual container.

### Note: Valgrind Suppression

To determine the correct valgrind suppression in the future, refer to [this manual](https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howtohttps://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto).
Running it on a sufficiently complex piece of leak-free code will yield most of the necessary configurations.

### Note: Hypervisor on Windows

If you plan to using Docker and Virtual Box as a fallback, please be aware of what you will need to do to switch between the two systems. You'll have to toggle the Hypervisor:

- Docker: Hypervisor **ON**
- VirtualBox: Hypervisor **OFF**

Here's how you can do that on Windows:

1. Press Windows key + X and select `Apps and Features`.
2. Scroll down to the bottom and click Programs and Features link.
3. Then click the Turn Windows Hypervisor on or off link on the left pane.

This issue **ONLY** concerns Windows users.
