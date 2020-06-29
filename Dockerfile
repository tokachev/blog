FROM ruby:2.7.1

RUN apt-get clean && apt-get update

RUN gem install bundler -v 2.1.4

RUN mkdir -p /app

WORKDIR /app

COPY . /app

RUN bundle install --path vendor/bundle
