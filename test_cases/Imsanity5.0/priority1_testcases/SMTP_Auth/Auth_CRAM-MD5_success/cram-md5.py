#!/usr/bin/env python
import hmac, hashlib
import sys

def cram_md5_response(username, password, base64challenge):
    return (username + ' ' +
            hmac.new(password,
                     base64challenge.decode('base64'),
                     hashlib.md5).hexdigest()).encode('base64')
#print cram_md5_response("user@example.com","password","PDQ1MDMuMTIyMzU1Nzg2MkBtYWlsMDEuZXhhbXBsZS5jb20+")
print cram_md5_response(sys.argv[1],sys.argv[2],sys.argv[3])
