#!/bin/bash

if [ ! -f /app/tmp/initialized ]
then
bundle
rake sq:create
rake sq:migrate
rake db:seed
touch /app/tmp/initialized
fi

passenger start
