.PHONY: up
up:
	@docker-compose up -d

.PHONY: migrate
migrate:
	@bundler exec rails db:migrate

.PHONY: seed
seed:
	@bundler exec rails db:seed

.PHONY: replant
replant:
	@bundler exec rails db:seed:replant

.PHONY: serve
serve:
	@bin/dev

.PHONY: console
console:
	@bundler exec rails console

.PHONY: test
test:
	@bundler exec rspec

.PHONY: format
format:
	@bundler exec rubocop -A

.PHONY: check-format
check-format:
	@bundler exec rubocop --fail-level=warning