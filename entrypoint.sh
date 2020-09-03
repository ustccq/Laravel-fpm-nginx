#!/bin/bash
set -eo pipefail
npm install
npm run prod
composer install
service nginx start
