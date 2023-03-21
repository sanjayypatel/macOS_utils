#!/bin/zsh
#Script: Generate a Password

# Script will pull from /usr/share/dict/words 
# Takes a number argument for number of passwords to generate.
# Passwords are three 5-letter words pulled at random.

num_passwords=$1

for i in i{1..$1} 
do
    password=$(grep '^.....$' /usr/share/dict/words | sort -R | head -3 | tr -d '\n')
    echo $password
done