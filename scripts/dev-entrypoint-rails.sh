#!/bin/bash
if [ -f tmp/pids/server.pid ]; then
  rm -rf tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0
