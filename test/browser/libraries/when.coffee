"use strict"

exports.name = "when.js"

exports.uri = "https://rawgithub.com/cujojs/when/master/when.js"

# This shim is described in the when.js readme for use without module loaders.
exports.shim = """
    window.define = function(factory) {
        try { delete window.define; } catch (e) { window.define = void 0; } // IE
        window.when = factory();
    };
    window.define.amd = {};
"""

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
    global.defer = when.defer;
"""
