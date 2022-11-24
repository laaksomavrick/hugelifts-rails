# README

## Developing on this codebase

### First time set up

* `nvm use`
* `bundler`
* `yarn`
* `make up`
* `bin/rails db:create`
* `bin/rails db:migrate`
* `make seed`
* `make serve`

### Daily dev flow

* `make seed`
* `make serve`

### Editing secrets:

`EDITOR="code --wait" rails credentials:edit`

## Deploying this codebase

* Setup git, docker, ssh on virtual machine
* Copy down repo, update CI config in Github secrets
* Setup env files from examples
  * `db.env`
  * `app.env`
  * `grafana.env`
* run `init-letsencrypt.sh` to set up ssl
* run `make up-prod`

