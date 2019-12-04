from base64 import b64encode

def send_payment(cc_number):
    with open("/tmp/transactions.txt", "w+") as f:
        plaintext = bytearray(cc_number, "utf-8")
        ciphertext = b64encode(plaintext)
        f.write(str(ciphertext))
