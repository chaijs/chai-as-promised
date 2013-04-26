"use strict"

exports.name = "Q"

exports.uri = "https://rawgithub.com/kriskowal/q/master/q.js"

exports.adapter = """
    global.fulfilledPromise = Q.resolve;
    global.rejectedPromise = Q.reject;
"""
