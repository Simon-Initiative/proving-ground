if [ ! -f DB_INITIALIZED ]; then
    # Create database
    mix ecto.create

    # Run migration to create schema
    mix ecto.migrate

    if [ "$MODE" = "development" ]; then
        # Seed the database with some development test data.
        mix run priv/repo/seeds.exs
    fi
fi

mix phx.server