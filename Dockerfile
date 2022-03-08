FROM elixir:1.12.1
SHELL ["/bin/bash", "-c"]

# nvm environment variables
ENV NVM_VERSION v0.39.1
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION v14.15.4

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y curl postgresql-client inotify-tools \
    && apt-get -y autoclean

# install nvm
# https://github.com/creationix/nvm#install-script
RUN mkdir -p $NVM_DIR && \
    curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

COPY . /app
WORKDIR /app
RUN source ~/.bashrc && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    npm ci --prefix assets && \
    mix do compile

EXPOSE 4000
CMD ["/app/cmd.sh"]
