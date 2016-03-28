#!/bin/bash
# export BUNDLE_PATH=/app/volumes/bundler
# export RACK_ENV=production
bundle

if [ ! -f /app/tmp/initialized ]
then
padrino rake db:reset
padrino rake db:seed
touch /app/tmp/initialized
else    
padrino rake db:migrate
fi
passenger start -d
top
