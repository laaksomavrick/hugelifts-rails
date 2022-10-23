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