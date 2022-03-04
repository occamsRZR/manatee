FROM elixir:1.12.1
SHELL ["/bin/bash", "-c"]

COPY . /app
WORKDIR /app
RUN apt-get update && \
    apt-get install -y postgresql-client inotify-tools && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    source /root/.bashrc && \
    nvm install v14.15.4 && \
    nvm use v14.15.4 && \
    ln -sf $(which node) /usr/bin/node && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    npm ci --prefix assets && \
    cd assets && \
    npx browserslist@latest --update-db && \
    cd /app && \
    mix do compile

EXPOSE 4000
CMD ["/app/cmd.sh"]
