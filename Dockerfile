ARG RUBY_VERSION
FROM ruby:2.6.6-buster

LABEL maintainer="dev@quintel.com"

RUN apt-get update -yqq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    nodejs

COPY Gemfile* /usr/src/app/
COPY lib/ymodel/* /usr/src/app/lib/ymodel/
WORKDIR /usr/src/app
RUN bundle install

COPY . /usr/src/app/

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
