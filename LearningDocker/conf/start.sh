#!/bin/bash

#Starting php
/usr/sbin/php-fpm

#Start nginx
nginx -g 'daemon off;'
