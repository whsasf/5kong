#!/usr/bin/env python3

import mxos_operations

result = mxos_operations.create_and_fetch_passphrase('10.49.58.241','8081','1003','aes-128-cbc','a4ef0211b5809a76')
print(result)