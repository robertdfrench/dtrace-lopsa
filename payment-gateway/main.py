from flask import Flask, escape, request
import pci

app = Flask(__name__)

@app.route('/purchase/<cardnumber>')
def purchase(cardnumber):
    pci.send_payment(cardnumber)
    return "Thank you for your purchase!\n"

@app.route('/')
def greet_customer():
    return "Hello, please buy something!\n"
