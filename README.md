virtualbox
=================

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [Modulename]](#setup)
 * [What [Modulename] affects](#what-[modulename]-affects)
 * [Setup requirements](#setup-requirements)
 * [Beginning with [Modulename]](#beginning-with-[Modulename])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview
This module manage installation of virtualbox. It work and it's tested on:
 * Windows 7 (x86/x64)
 * Ubuntu 12.04 (but it should work in 10.04 and earlier)

##Module Description
 * In a windows environment this module:
    * download the installation file in a tmp\_dir and, after, it installs it
    * download and install Oracle VirtualBox VM Extension Pack
 * in a linux environment it use the package resource. Last version present in ubuntu repository will be installed


