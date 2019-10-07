# Proving Ground

Testbed for proving out future Simon/OLI technologies.

## Dependencies

Have installed the following:

- Elixir
- Phoenix
- Docker

## Setup Instructions

1. Start dockerized postgres:
```
$ ./db.sh
```
2. Install node and mix dependencies:
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


