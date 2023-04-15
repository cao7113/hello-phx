# Notes

  mix phx.gen.json Crypto Token tokens name:string url:string intro:text --web Crypto
  mix phx.gen.html Learn Book books name:string url:string intro:text --web Learn

## Init info

Fetch and install dependencies? [Yn] y
* running mix deps.get
* running mix assets.setup
* running mix deps.compile

We are almost there! The following steps are missing:

    $ cd hello-phx

Then configure your database in config/dev.exs and run:

    $ mix ecto.create

Start your Phoenix app with:

    $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phx.server