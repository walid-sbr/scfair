#!/bin/bash

rm -f ./tmp/pids/server.pid

# Install node_modules if doesn't exist in container
if [ ! -d "node_modules" ]; then
    npm i
fi

bundle install

if [ ! -f "config/sunspot.yml" ]; then
    rails generate sunspot_rails:install
fi

sed -i 's/exists/exist/g' /usr/local/bundle/gems/sunspot_solr-2.6.0/lib/sunspot/solr/server.rb


bundle exec rake sunspot:solr:run & yarn build --watch=forever & yarn build:css --watch & ./bin/rails server -b "0.0.0.0" && fg 