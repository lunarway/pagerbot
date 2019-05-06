FROM ruby:2.5.5-alpine3.9

RUN apk update && \
  apk add git g++ make openssl openssl-dev tzdata

RUN mkdir /pagerbot

ENV TZ=Europe/Copenhagen

WORKDIR /pagerbot
ADD Gemfile* *.gemspec /pagerbot/
RUN bundle install
ADD . /pagerbot


ENV LOG_LEVEL 'debug'
ENV MONGODB_URI 'mongodb://mongo:27017/pagerbot'

EXPOSE 4567
