VERSION=latest
SECRET_KEY_BASE := $(shell eval RAILS_ENV=production rake secret)

.PHONY: up
up:
	@docker-compose up -d

.PHONY: migrate
migrate:
	@bundler exec rails db:migrate

.PHONY: seed
seed:
	@bundler exec rails db:seed:replant

.PHONY: serve
serve:
	@bin/dev

.PHONY: console
console:
	@bundler exec rails console

.PHONY: test
test:
	@bundler exec rspec && yarn test

.PHONY: format
format:
	@bundler exec rubocop -A && yarn format && yarn lint

.PHONY: check-format
check-format:
	@bundler exec rubocop --fail-level=warning && yarn format:check && yarn lint

.PHONY: build
build:
	@docker build --build-arg SECRET_KEY_BASE=$(SECRET_KEY_BASE) -f Dockerfile -t hugelifts:$(VERSION) .
