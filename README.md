# Proving Ground

Testbed for proving out future Simon/OLI technologies.

## Dependencies

Have installed the following:

- Elixir (`$ brew install elixir`)
- Phoenix (`$ mix archive.install hex phx_new 1.4.10`)
- Docker

## Setup Instructions

1. Start dockerized postgres 12 via the included convenience script:
```
$ ./db.sh
```
2. Install client and server dependencies:
```
$ cd assets && npm install
$ mix deps.get
```
3. Create database
```
$ mix ecto.create
```
4. Run migration to create schema
```
$ mix ecto.migrate
```
5. Seed the database with some test data.
```
$ mix run priv/repo/seeds.exs
```
6. Start Phoenix server
```
$ mix phx.server
```
7. Access the app at `localhost:4000`

