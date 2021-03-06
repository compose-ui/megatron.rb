FROM mhart/alpine-node:5.0

ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base git
ENV RUBY_PACKAGES ruby ruby-bundler ruby-nokogiri

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    apk add --update build-base libffi-dev && \
    rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ADD . /app
RUN bundle install --jobs 4 --without development test

RUN npm install

WORKDIR /app

ENV RAILS_ENV production
ENV MEGATRON_FORCE_LOCAL_ASSETS true
RUN bundle exec cyborg build -P
RUN cd site && bundle exec rake tmp:cache:clear
RUN cd site && bundle exec rake assets:precompile

CMD bundle exec cyborg s -p $PORT -b 0.0.0.0
