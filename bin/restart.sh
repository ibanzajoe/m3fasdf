#!/bin/bash
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
parentdir="$(dirname "$dir")"
app=${parentdir##*/}
docker exec -it ${app}_app_1 passenger stop
docker exec -it ${app}_app_1 bundle
docker exec -it ${app}_app_1 padrino rake db:migrate
docker exec -it ${app}_app_1 passenger start --pool-idle-time=0 -d
./logs.sh

