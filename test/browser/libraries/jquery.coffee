"use strict"

exports.name = "jQuery"

exports.uri = "https://code.jquery.com/jquery-3.0.0-beta1.js"

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
    global.defer = function () {
        var deferred = jQuery.Deferred();
        return {
            promise: deferred.promise(),
            resolve: deferred.resolve,
            reject: deferred.reject,
        };
    };
    global.getPromise = function (deferred) {
        return deferred.promise();
    };
    global.waitAll = function (promises) {
        return jQuery.when
            .apply(null, promises)
            .then(function () {
                return Array.prototype.slice.call(arguments);
            });
    };
"""
