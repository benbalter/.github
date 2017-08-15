# Probot Config

Shared configuration file for [probot](https://github.com/probot/) plugins.

## What it does

* Syncs shared `.github/*` files across multiple repositories
* Installs applications
* Configures repository settings
* Saves maintainers time and clicks 

## Setup

1. Clone locally
2. `script/bootstrap`
3. (Optional) Create a `.env` file in the repo root with `OCTOKIT_ACCESS_TOKEN=XXXX` where XXX is a personal access token with `repo` scope

## Usage

1. Customize the `.github/*` files
2. Customize `/deploy.yml` with your repositories and apps
3. Run `script/deploy`
