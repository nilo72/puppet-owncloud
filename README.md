# puppet-owncloud
===============

[![Build Status](https://travis-ci.org/haw-hh-ai-lab/puppet-owncloud.svg?branch=master)](https://travis-ci.org/haw-hh-ai-lab/puppet-owncloud)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with [modulename]](#setup)
    * [What [modulename] affects](#what-[modulename]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [modulename]](#beginning-with-[modulename])
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This ownCloud module supports installation and configuration of an ownCloud.
This module also trys to implement some configuration recomendations give by owncloud.

For example...


## Module Description

## Setup

### What owncloud affects

### Setup Requirements

### Beginning with ownCloud

To install ownCloud with the default parameters:

```class { '::owncloud':
      ...
      manage_apache => false,
    }
```

#### Install on a single server


#### Install on separate database and web server


#### Install and configure Apache to use SSL


#### Install and manage only ownCloud


## Usage

### The `owncloud` class

#### Parameters

##### `admin_pass`

Optionally set the admin password in the ownCloud configuration.

##### `admin_user`


## Reference

### Classes

#### Public Classes

* `owncloud`: Guides the installation of ownCloud (including database creation and user data directory if specified).
* `owncloud::database`: Installs the ownCloud database; include this on your database server if it is separate to the web server (not required if database and application run on same server).

#### Private Classes

* `owncloud::apache`: Installs and configures Apache when `manage_apache` is set to `true`.
* `owncloud::config`: Configures ownCloud using autoconfig.php (and creates/exports a database).
* `owncloud::install`: Installs ownCloud (using the ownCloud repository).
* `owncloud::params`: Manages ownCloud operating system specific parameters.

## Limitations

* This module does not install a database server. An example has been provided on how to do this using [PuppetLabs MySQL module](https://github.com/puppetlabs/puppetlabs-mysql).

* This module has been tested on the following Operating Systems:

    * CentOS 6

## Development

Pull requests are welcome, please see the [contributing guidelines](https://github.com/nilo72/puppet-owncloud/blob/CONTRIBUTING.md).