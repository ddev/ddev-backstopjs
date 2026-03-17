[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/ddev/ddev-backstopjs/actions/workflows/tests.yml/badge.svg)](https://github.com/ddev/ddev-backstopjs/actions/workflows/tests.yml)
[![last commit](https://img.shields.io/github/last-commit/ddev/ddev-backstopjs)](https://github.com/ddev/ddev-backstopjs/commits)
[![release](https://img.shields.io/github/v/release/ddev/ddev-backstopjs)](https://github.com/ddev/ddev-backstopjs/releases/latest)

## DDEV BackstopJS

## Overview

[BackstopJS](https://github.com/garris/BackstopJS) is a visual regression testing tool.

This add-on provides the basics to run BackstopJS into your [DDEV](https://ddev.com) project. No backstopjs config is included. See below how to generate a
config and for links to a more advanced example config.

## Installation

```bash
ddev add-on get ddev/ddev-backstopjs
ddev restart
```

After installation, make sure to commit the `.ddev` directory to version control.

> [!NOTE]
> If you haven't downloaded the backstopjs base image before, then it will be downloaded when DDEV is restarted.
> The `backstopjs/backstopjs` is about 2.6 GB, so this may take some time.

## Usage

### Configuration

By default, the backstop tests are expected in `$DDEV_APPROOT/tests/backstop`.

Provide your own `backstop.js` or `backstop.json` configs there.

> [!TIP]
> Have a look at this example for [backstopjs-config](https://github.com/mmunz/backstopjs-config),

Alternatively, create a simple `backstop.json` config with:

```bash
ddev backstop init
```

### Run tests

After you created the config, you can run the tests.

Create reference screenshots:

```bash
ddev backstop reference
```

Create test images and compare to reference screenshots:

```bash
ddev backstop test
```

If your config file is not `backstop.json`, use the `--config` argument, for example `--config=backstop.js`.

### View test results

The BackstopJS commands `backstop remote` and `backstop openReport` don't work in this setup.

However, there is a host command that opens the latest test report in your default browser:

```bash
ddev backstop-results
```

Alternatively, open the generated HTML report in your browser, for example:

```bash
open tests/backstop/backstop_data/_mytestproject_/html_report/index.html
```

## Changes to the original Docker image

The BackstopJS Docker image is extended with additional functionality using a custom Docker build. See [Dockerfile](backstopBuild/Dockerfile) and the custom [entrypoint](backstopBuild/entrypoint.sh).

In the `Dockerfile`, the following changes are made:

- Add the custom `entrypoint.sh` to the image
- Delete the default `node` user with UID 1000 and add the current DDEV user
- Install the [minimist](https://www.npmjs.com/package/minimist) npm package globally. This is not required by default but is useful for parsing command-line arguments in more complex BackstopJS configs.

The entrypoint is responsible for:

- Adding `/etc/hosts` entries for all hosts configured in the DDEV web container
- Adding a `sleep` command to keep the container running

## Advanced Customization

### Change the BackstopJS tests directory

By default, the `backstop` directory (which contains the BackstopJS config and related files) is expected in your project directory, next to the `.ddev` folder, at `tests/backstop`.

To change this, edit the file [docker-compose.backstop.yaml](docker-compose.backstop.yaml) and update the path in the `volumes` section. Move your files to the new directory and restart DDEV.

Make sure to remove the `#ddev-generated` line from the file to prevent DDEV from modifying it.

## Credits

**Contributed and maintained by [@mmunz](https://github.com/mmunz)**
