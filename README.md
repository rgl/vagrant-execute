# Vagrant Execute Command

This is a Vagrant plugin to execute commands inside a VM from the host machine.

**NB** This was only tested with Vagrant 1.9.2 and Windows Server 2016.

# Installation

```bash
vagrant plugin install vagrant-execute
```

# Usage

The general syntax is:

```plain
vagrant execute [vm-name] [--sudo] <-c|--command> <command>
```

To troubleshoot, set the `VAGRANT_LOG` environment variable to `debug`.

## Example

In this repo there's an example [Vagrantfile](Vagrantfile). Use it to launch
an example.

Install the [Base Windows Box](https://github.com/rgl/windows-2016-vagrant).

Launch the VM:

```bash
vagrant up
```

Execute a command without and with administrative privileges and compare the results:

```bash
vagrant execute -c 'whoami /all'        >whoami.txt
vagrant execute -c 'whoami /all' --sudo >whoami-sudo.txt
meld whoami.txt whoami-sudo.txt # or diff -u whoami.txt whoami-sudo.txt
```

# Development

To hack on this plugin you need to install [Bundler](http://bundler.io/)
and other dependencies. On Ubuntu:

```bash
sudo apt install bundler libxml2-dev zlib1g-dev
```

Then use it to install the dependencies:

```bash
bundle
```

Build this plugin gem:

```bash
rake
```

Then install it into your local vagrant installation:

```bash
vagrant plugin install pkg/vagrant-execute-*.gem
```

You can later run everything in one go:

```bash
rake && vagrant plugin uninstall vagrant-execute && vagrant plugin install pkg/vagrant-execute-*.gem
```
