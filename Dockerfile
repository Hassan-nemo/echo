FROM ruby:3.2.0-alpine

RUN apk add --update --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    tzdata \
    postgresql-dev \
    libc-dev \
    linux-headers \
    shared-mime-info \
    file-dev \
    git \
    less \
    curl \
    nano \
    imagemagick \
    nodejs \
    yarn \
    npm \
    bash \
    openssh-client \
    inotify-tools # Add this package for code reloading

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Hassan Mahmoud <hassantc.mahmoud@gmail.com>"

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
