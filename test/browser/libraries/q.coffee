exports.name = "Q"

exports.uri = "https://raw.github.com/kriskowal/q/master/q.js"

# Q.js doesn't work under mocha, because mocha stubs out some
# node.js globals, making it think it's running in node.
# Unsetting this makes it work:

exports.shim = """
  window.process = undefined;
"""

exports.adapter = """
    global.fulfilledPromise = Q.resolve;
    global.rejectedPromise = Q.reject;
"""
