FROM elixir

RUN git clone https://github.com/samuelleeuwenburg/Eli.git

WORKDIR /Eli

RUN sh -c '/bin/echo -e "yes" | mix local.hex'
RUN mix deps.get
RUN mix compile

CMD mix run --no-halt
