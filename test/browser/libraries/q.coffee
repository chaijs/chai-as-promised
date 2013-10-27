"use strict"

exports.name = "Q"

exports.uri = "https://s3-us-west-1.amazonaws.com/q-releases/q.js"

exports.adapter = """
    global.fulfilledPromise = Q.resolve;
    global.rejectedPromise = Q.reject;
    global.defer = Q.defer;
"""
