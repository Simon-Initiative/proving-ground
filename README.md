# Proving Ground

Testbed for proving out future Simon/OLI technologies.

## Dependencies

Have installed the following:

- Elixir (`$ brew install elixir`)
- Phoenix (`$ mix archive.install hex phx_new 1.4.10`)
- Docker

## Setup Instructions

1. Start dockerized postgres via the included convenience script:
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
5. Start Phoenix server
```
$ mix phx.server
```


