# CSCI 104 Docker

<a href="https://hub.docker.com/repository/docker/usccsci104/docker">
  <img align="left" src="https://img.shields.io/docker/image-size/usccsci104/docker?style=flat-square" />
</a>

<a href="https://hub.docker.com/repository/docker/usccsci104/docker">
  <img align="left" src="https://img.shields.io/docker/pulls/usccsci104/docker" />
</a>

</br>

## Introduction

This repository contains a Dockerfile and a couple of management scripts for creating and using a virtualized Linux container capable of building, running, and debugging C++.
Using a virtualized container is preferable to a user's local machine because it guarantees consistent compilation and execution of C++ binaries.
While compilers and tooling may vary between systems, creating a sealed environment from the exact same components every time ensures that code runs the same for graders as it does students.

But why use Docker over a traditional virtual machine?
Docker is considerably less resource-intensive than installing a full virtual machine.
Instead of needing the facilities for a graphical interface, virtual file system, etc., we can mount any directory of the host machine directly in the container and use a shell to run compilation and debugging.
Development and file management may be done normally on the local machine.

Feel free to read through the [wiki](https://github.com/csci104/docker/wiki) for **a more in-depth guide on [how setup and use Docker](https://github.com/csci104/docker/wiki/Usage)** as well as [how it works](https://github.com/csci104/docker/wiki/Details).

## Installation
### Prerequisites

You will be running a lot of commands in the terminal to set this up. If you have not done
this before, we *highly recommend* checking out CP Jamie Flores' great [Linux](https://bytes.usc.edu/cs104/wiki/linux) wiki.
Specifically, you'll want to look at the [Navigating Directories](https://bytes.usc.edu/cs104/wiki/linux/#navigating-directories) section.

Please make sure that your machine meets the requirements for Docker Desktop, which you will install in [Step 1](#step-1-install-docker):

<a href="https://docs.docker.com/docker-for-windows/install/" target="_blank">Windows host:</a>

- Windows 10 64-bit: (Build 18362 or later)
  - WSL2 container backend

> **Optional:** If you are using Windows 10 Home, you can obtain a "free" license for Windows 10 Education <a href="https://viterbiit.usc.edu/services/hardware-software/microsoft-imagine-downloads/">here</a>.

<a href="https://docs.docker.com/docker-for-mac/install/" target="_blank">Mac host:</a>

- Intel:
  - Mac hardware must be a 2010 or newer model
  - macOS must be version 10.13 or newer
  - 4 GB RAM minimum
- Apple Silicon (i.e. M1 chip):
  - Rosetta emulated terminal
    - for instructions on how to setup a Rosetta emulated terminal, see
    <a href="https://osxdaily.com/2020/11/18/how-run-homebrew-x86-terminal-apple-silicon-mac/" target="_blank">instructions here</a>
    to run Terminal through Rosetta.

> **Note:** The gdb debugger used in CSCI104 may not work on Apple Silicon per [this Github issue](https://github.com/docker/for-mac/issues/5191#issue-775028988).

### Step 0: Install WSL2 (Windows only)

If you are using macOS or Linux operating system, you can skip this section.
If you are running Windows, you must install the Windows Subsystem for Linux 2 (WSL2) before installing Docker.

Follow the instructions below to install WSL2 on your machine: <a href="https://docs.microsoft.com/windows/wsl/install-win10" target="_blank">Windows Subsystem for Linux Installation Guide</a>


### Step 1: Install Docker


Install Docker Desktop from <a href="https://www.docker.com/products/docker-desktop" target="_blank">the website</a>

When the installation has finished, open up Docker Desktop to make sure it's running. If Docker is running
properly, you will see a green icon in the lower left side.

If you encounter errors in this process, please see the <a href="https://github.com/csci104/docker/wiki/Troubleshooting" target="_blank">Troubleshooting wiki</a>.

### Step 2: Create a working directory

We highly recommend that you create a dedicated working directory to clone CSCI 104
repositories and to do your programming assignments.

Create a `csci104` folder on your machine. Next, you'll need to open a terminal into
the folder to run the remaining commands in the setup.

Open up a Terminal (macOS) or Powershell/Windows Terminal (Windows). Next, navigate
to your `csci104` folder by typing `cd ` (notice the space) and dragging the
`csci104` folder from Finder or File Explorer into the terminal, then press enter.

### Step 3: Clone this repository

After setting up Docker, you need to clone this repository which contains
a setup script for both Windows and Unix-based systems.


Run the commands below to clone the repository and change directories into the new folder:

```shell
git clone git@github.com:csci104/docker.git
cd docker
```

If this command fails with an error like `git command not found`, you need to
install the git command-line interface (CLI). See <a href="https://git-scm.com/downloads" target="_blank">this link</a>
and download the version for your operating system.

The `git clone` command downloads a repository (think of it as a folder) from the Github URL. To learn more about what the `cd` command does, take a look at the <a href="https://bytes.usc.edu/cs104/wiki/linux/#navigating-directories" target="_blank">Linux wiki</a>.

### Step 4: Run the setup script

This repository contains a setup script to install a command-line tool you will
use to access your Docker containers, pull the CSCI 104 docker image and setup your virtualized environment.

If you followed [Step 3](#step-3-clone-this-repository) properly, you have a terminal open
in the docker folder. If you're not sure, see the [Filepaths in the Terminal](#filepaths-in-the-terminal) tip.

Now that you're ready to run the setup script, read and follow the instructions
below corresponding to your operating system:

**macOS/Linux**

On macOS in Terminal, run the respective setup script inside the `docker` folder:

```bash
./unix/setup.sh
```

> Note: if you're not able to run `ch` after setup, you may need to run `source ~/.zshrc` or `source ~/.bashrc`
> depending on your default shell. If you don't understand what this means, you can safely ignore the comment!

**Windows**

On Windows in PowerShell or Windows Terminal, the process is similar but you must make sure you can run PowerShell scripts:

Make sure you run this in an Admin PowerShell:

```powershell
# must execute this in admin powershell and select [A] to run scripts
Set-ExecutionPolicy RemoteSigned
```

In PowerShell, run this command in the `docker` folder:

```powershell
.\windows\setup
```

### Step 5: Set your working directory

If the command above runs successfully, you will be prompted to provide the directory in your local machine you wish to be accessible from the virtual machine.

If you followed [Step 2](#step-2-create-a-working-directory), you will drag the
`csci104` folder you created into your terminal from Finder/File Explorer. See
the [Filepaths in the Terminal](#filepaths-in-the-terminal) tip for more help.


### Step 5: Verify your installation

Once you've finished answering the prompts and setup script finishes, you should be ready to use `ch` to work with your csci104 environment!

> If you're on macOS, try running `source ~/.zshrc` or `source ~/.bashrc` and then run `ch list`.
If this fails, try opening up a new terminal and retry the command. If this fails, you can
ask a CP, post on Piazza, or <a href="https://github.com/csci104/docker/issues/new/choose" target="_blank">create a Github Issue</a> if
you're not in the class but still need help.

Let's check and make sure everything works by running `ch list` in your terminal.
You should get output like this below, but don't worry if the filepath in `Volume`
looks a little different:

**macOS**

```shell
$ ch list
Name:   csci104
        Image:  usccsci104/docker:20.04
        Volume: /Users/username/csci104:/work
        SecOpt: seccomp:unconfined
        CapAdd: SYS_PTRACE
```

**Windows**

```powershell
PS C:\Users\Username> ch list
Name:   csci104
        Image:  usccsci104/docker:20.04
        Volume: C:\Users\Username\csci104:/work
        SecOpt: seccomp:unconfined
        CapAdd: SYS_PTRACE
```

If you see output something like this, you're all set up! Congrats!

## Working

The `ch` (container-helper) command-line tool allows you to create and access Docker environments.
When you ran the `setup` script, it created and pulled a Docker image made for
compiling, running and debugging C++ code in CSCI 104. To run this environment,
you can run this command (the same for both Unix and Windows systems):

```bash
ch COMMAND csci104
```

There are three commands you will regularly use:
- The first, `start`, starts the container up in the background.
  The container should continue running until you shut down your computer, exit docker, or kill the container manually.
- Next is `shell`, which simply opens a shell inside the virtual machine.
  This is where you can run standard linux commands, such as `g++` or `valgrind`. You can exit the shell with the key sequence <Ctrl+D>
- The last is `stop`, which manually shuts down the virtual container.


You will use the `ch shell csci104` command to access the Docker container and compile or execute your code and run the
autograder tests after assignments are graded. Anytime you need to push code to Github, make sure to exit the container.
This last note deserves some emphasis:


> **You should not run any git commands in Docker**. This means you should not
> run `git pull`, `git push`, `git clone`, etc after running `ch shell csci104`.


### Example

See full documentation for `ch` <a href="https://github.com/camerondurham/ch" target="_blank">here</a>.

```bash
# start your environment
ch start csci104

# get a shell into the csci104 environment
ch shell csci104

# exit the shell with <Ctrl+D> or typing `exit`

# stop the running environment
ch stop csci104
```

## Tips

### Filepaths in the terminal

For the installation script and when navigating your terminal for the first
time, you might need to provide a filepath. This represents where on your
machine a specific folder or file is located. For more about this and
terminal commands in general, please check out the
[Linux wiki](https://bytes.usc.edu/cs104/wiki/linux/#navigating-directories).

There are many ways to do this, but this seems like the easiest way for
people getting used to using their terminal:

1. open Finder (macOS) or File Explorer (Windows)
2. find the folder where you want to go to
3. drag the path into your terminal to get the path

If you're wanting to change directories like in [Step 3](#step-3-clone-this-repository), you'll type `cd ` into your terminal and
drag the folder in.

If you're running the setup script in [Step 4](#step-4-run-the-setup-script), you will drag your csci104 folder in the terminal
when the script asks for a filepath.
### Valgrind Suppression

To determine the correct valgrind suppression in the future, refer to [this manual](https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howtohttps://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto).
Running it on a sufficiently complex piece of leak-free code will yield most of the necessary configurations.

### Hypervisor on Windows

If you plan to using Docker and Virtual Box as a fallback, please be aware of what you will need to do to switch between the two systems. You'll have to toggle the Hypervisor:

- Docker: Hypervisor **ON**
- VirtualBox: Hypervisor **OFF**

Here's how you can do that on Windows:

1. Press Windows key + X and select `Apps and Features`.
2. Scroll down to the bottom and click Programs and Features link.
3. Then click the Turn Windows Hypervisor on or off link on the left pane.

This issue **ONLY** concerns Windows users.
