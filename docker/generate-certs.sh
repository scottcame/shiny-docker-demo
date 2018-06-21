#!/bin/bash

# typically you'll only need to do this if you want to refresh the certs...not needed after initial generation, even for subsequent builds
# including this script mostly to document how we generated the certs in the first place

# borrowed liberally from https://wiki.shibboleth.net/confluence/display/CONCEPT/SAMLKeysAndCertificates#SAMLKeysAndCertificates-CreatingaSAMLKeyandCertificate

# Service Provider cert/key
openssl req -new -x509 -nodes -newkey rsa:2048 -keyout shiny-apache-shib-sp/files/sp-key.pem -days 7300 -out shiny-apache-shib-sp/files/sp-cert.pem -subj "/C=US/ST=WA/L=Olympia/O=Cascadia Analytics/CN=localhost.localdomain/emailAddress=docker@localhost"

# Identity Provider cert/key
openssl req -new -x509 -nodes -newkey rsa:2048 -keyout shiny-idp/files/idp-signing-key.pem -days 7300 -out shiny-idp/files/idp-signing-cert.pem -subj "/C=US/ST=WA/L=Olympia/O=Cascadia Analytics/CN=localhost.localdomain/emailAddress=docker@localhost"
