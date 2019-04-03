#! /bin/bash

# $1: subject
# $2: address
sed '1!b;s/^/To: '"$2"'\nSubject: '"${1}"'\n\n/' | sendmail -t
