exports.name = "when.js"

exports.uri = "https://raw.github.com/cujojs/when/master/when.js"

exports.adapter = """
    global.fulfilledPromise = function (value) {
        var deferred = when.defer();
        deferred.resolve(value);
        return deferred.promise;
    };
    global.rejectedPromise = function (reason) {
        var deferred = when.defer();
        deferred.reject(reason);
        return deferred.promise;
    };
"""
