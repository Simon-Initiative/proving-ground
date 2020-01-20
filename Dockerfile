FROM elixir:1.9

WORKDIR /usr/src/app

# Copy all app files to image, excluding those in .dockerignore
COPY . .

RUN chmod +x /usr/src/app/entrypoint.sh

# Install dependencies
RUN mix local.hex --force
RUN mix archive.install hex phx_new 1.4.10

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install nodejs
RUN cd assets && npm install
RUN mix deps.get

EXPOSE 4000
CMD [ "sh", "/usr/src/app/entrypoint.sh" ]
