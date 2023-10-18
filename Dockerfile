FROM ruby:3.2.2-alpine
RUN apk add postgresql-dev git build-base nodejs bash npm
RUN mkdir -p /opt/mimemagic
WORKDIR /opt/scfair
ENV FREEDESKTOP_MIME_TYPES_PATH=/opt/mimemagic
COPY src/Gemfile .
#CMD ["rails", "new", "scfair", "-j", "esbuild", "-d", "postgresql", "--css", "bootstrap"]
#RUN bundle install
#COPY src/. .
CMD ["./bin/dev"]