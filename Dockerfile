FROM elixir:1.13.3-alpine

RUN mix local.hex --force && \
    mix local.rebar --force
    
WORKDIR /app

COPY . .

RUN mix do deps.get, deps.compile

CMD ["mix", "phx.server"]