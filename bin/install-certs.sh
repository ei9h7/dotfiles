#!/bin/sh
#
# Certificates
#
# This installs certificates

  echo "  Downloading cloudflare root crt."
  
  /bin/bash wget "https://developers.cloudflare.com/cloudflare-one/9922abcf75b55a3bb68a8e42ebe5c4a5/Cloudflare_CA.crt)"
  
  # Test for Linux or macOS
  if test "$(uname)" = "Darwin"
  then
    echo "  Installing the Cloudflare certificate to the Base System"
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain Cloudflare_CA.crt
    echo "  Updating the OpenSSL CA Store to include the Cloudflare certificate"
    sudo cat Cloudflare_CA.crt >> /usr/local/etc/openssl/cert.pem
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    
  fi

exit 0
