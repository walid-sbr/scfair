FROM ruby:3.2.2-alpine
RUN apk add postgresql-dev git build-base nodejs bash npm yarn busybox-extras curl wget
RUN mkdir -p /opt/mimemagic
WORKDIR /opt/scfair
ENV FREEDESKTOP_MIME_TYPES_PATH=/opt/mimemagic
COPY src/Gemfile .
RUN bundle install
COPY src/. .
#CMD ["rails", "new", "scfair", "-j", "esbuild", "-d", "postgresql", "--css", "bootstrap"]
CMD ["rm ./tmp/pids/server.pid"]
CMD ["./bin/dev"]
#CMD ["sh ./bin/start.sh"]