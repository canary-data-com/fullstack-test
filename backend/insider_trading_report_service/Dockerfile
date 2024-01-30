FROM elixir:1.16.0

RUN apt-get update && \
    apt-get install --yes build-essential inotify-tools postgresql-client git && \
    apt-get clean

ENV MIX_ENV=prod

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .

RUN mix compile

#RUN mix ecto.create

#RUN mix ecto.migrate

RUN mix release

RUN chmod +x entrypoint.sh

#CMD ["_build/prod/rel/insider_trading_report_service/bin/insider_trading_report_service", "start"]

EXPOSE 4000

CMD ["/app/entrypoint.sh"]
