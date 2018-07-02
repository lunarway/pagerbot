FROM ruby:2.5

RUN apt-get update; apt-get install libgmp3-dev openssl libssl-dev --assume-yes
RUN mkdir /pagerbot

WORKDIR /pagerbot
ADD Gemfile* *.gemspec /pagerbot/
RUN bundle install
ADD . /pagerbot


ENV LOG_LEVEL 'debug'
ENV MONGODB_URI 'mongodb://mongo:27017/pagerbot'

EXPOSE 4567
