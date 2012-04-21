exports.name = "Q"

exports.uri = "https://raw.github.com/kriskowal/q/master/q.js"

exports.adapter = """
    global.fulfilledPromise = Q.resolve;
    global.rejectedPromise = Q.reject;
"""
