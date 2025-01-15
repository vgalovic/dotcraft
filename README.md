Dotcraft
========================================

This is my *dotfiles repository*, which includes all my configuration files located in the `config` folder. The repository also contains installation scripts in the `install` folder to help you configure your system, meant for *Ubuntu* (or *Linux Mint*).

Prerequisites
 ----------------------

Ensure that *git* is installed:

```bash
sudo apt update && sudo apt install -y git
```

Cloning the Repository
 ----------------------

You can clone this repository by running:

```bash
git clone https://github.com/vgalovic/dotcraft.git ~/.dotfiles
cd .dotfiles
```

Making Scripts Executable
 ----------------------

To run the scripts, you’ll first need to make them executable. Use the following commands in your terminal:

```bash
chmod +x install/*.sh
chmod +x install/setup/*.sh
```

Running the Setup Script
 ----------------------

After making the scripts executable, you can run the main setup script with:

```bash
./install/run.sh
```

> 📝 **Note:** Running `run.sh` will automatically prompt you to restart your computer.A restart is required to complete the initial setup. Be sure to save any open work before proceeding.

Post-Setup
----------------------

After restarting, you may want to run `post_run.sh` to complete the setup and install some none essential packages. To do so open a terminal and run:

```bash
cd .dotfiles
./install/post_run.sh 
```

These commands can't be run from `run.sh` directly.

Troubleshooting
 ----------------------

The scripts will log their output to `script_output.log`. If something goes wrong during the setup process, you can check this log file to see what happened. This applies to both the `run.sh` script and `post_run.sh`.

```bash
cat ~/.dotfiles/install/output.log
```
