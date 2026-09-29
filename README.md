# Setup
- Personal and work laptop configuration scripts

## Setup
Before running anything you need to get a few packages: 

### For Arch
```bash
sudo pacman -S git
```

### For Debian
```bash
sudo apt install git
```

This are needed for the script running.
Afterwards you need to clone this repo and run it with the specified flags for each functionality:

```bash 
git clone https://github.com/JoaoCLouro/Setup

chmod +x Setup
./Setup/runner.sh [flags]
```

## TODO
* Improve DE setup;
* Flag reading for setup config

## NOTES
* Debian setup is discontinued as **arch is vastly superior**

* Each distribution main setup script will ask for a user name and email for github. To skip this setups **make sure you are logged in on your github account in you terminal**
