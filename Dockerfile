FROM ruby:3-alpine

WORKDIR /workspace

COPY ./Gemfile* /workspace
RUN gem install bundler && \
  bundle install

COPY ./ /workspace/
