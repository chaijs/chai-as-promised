exports.name = "jQuery"

exports.uri = "http://code.jquery.com/jquery.js"

exports.adapter = """
    global.fulfilledPromise = function (value) {
        var deferred = jQuery.Deferred();
        deferred.resolve(value);
        return deferred.promise();
    };
    global.rejectedPromise = function (reason) {
        var deferred = jQuery.Deferred();
        deferred.reject(reason);
        return deferred.promise();
    };
"""
