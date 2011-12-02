#!/bin/sh

cd "$(dirname "$0")"

export CAMELLIA_HOME=$(cd ../../../../.. && pwd)

exec ruby \
  -I . \
  -I "$CAMELLIA_HOME/tools/lib/ruby" \
  -r "$CAMELLIA_HOME/acceptance/lib/ruby/camellia/load_path_bootstrap.rb" \
  -r gatling.rb \
  -e 'LocalGatling.exec' -- "$@"
