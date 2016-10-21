#!/bin/sh

export pass=badpassword

openssl genrsa -des3 -passout env:pass -out ca.key 1024
openssl req -new -x509 -days 3650 -key ca.key -passin env:pass -out ca.crt -subj "/CN=ca@example.com"
openssl x509  -in  ca.crt -out ca.pem
openssl genrsa -des3 -passout env:pass -out server_encrypted.key 1024
openssl rsa -in server_encrypted.key -passin env:pass -out server.key
openssl req -new -key server.key -out server.csr -passin env:pass -subj "/CN=lb.example.com"
openssl x509 -req -days 3650 -in server.csr -passin env:pass -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
