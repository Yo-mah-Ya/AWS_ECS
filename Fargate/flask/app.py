# -*- encoding:utf-8 -*-
import json
import os
from logging import getLogger, StreamHandler, DEBUG, INFO, WARNING, ERROR, CRITICAL
import sys
# Third party
import boto3
from flask import Flask, render_template, request

app = Flask(__name__)

# logger setting
logger = getLogger(__name__)
handler = StreamHandler()
handler.setLevel(DEBUG)
logger.setLevel(os.getenv("LogLevel", DEBUG))
logger.addHandler(handler)
logger.propagate = False

# Enable CORS
@app.after_request
def after_request(response):
    logger.debug(f"\033[33m{sys._getframe().f_code.co_name} function called\033[0m")
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response

# Get
@app.route('/get')
def get():
    logger.info(request.args)
    if "id" not in request.args:
        return json.dumps({"message": "send message"})


    return json.dumps({"message": "OK"})

# Post
@app.route('/post',methods=["POST"])
def post():
    logger.debug(f"request.json = {request.json}")

    if "id" not in request.json:
        return json.dumps({"message": "send message"})

    return json.dumps({"message": "OK"})

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=3000)
