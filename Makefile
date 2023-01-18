#!make
include .env

build: 
	docker compose build

mix_deps:
	docker compose run --rm blackbox mix do deps.get, deps.compile

start:
	docker compose up

iex_phx:
	docker compose run --rm -p 4000:4000 blackbox iex -S mix phx.server

setup:
	make build && make mix_deps && make ecto_create && make ecto_migrate && make seeds && make start

ecto_create:
	docker compose run --rm blackbox mix ecto.create

ecto_migrate:
	docker compose run --rm blackbox mix ecto.migrate

test:
	docker compose run --rm blackbox mix test

seeds:
	docker compose run --rm blackbox mix seeds
