#!/bin/sh
if["${RAILS_ENV}"="prodction"]
then
bundle exec rails assets:precompile
fi

bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0