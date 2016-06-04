"use strict";

// Note: this file is used both in the Node and browser tests.

(function () {
    var Q = global.Q || (typeof require === "function" && require("q"));
}());

global.shouldPass = function (promiseProducer) {
    it("should return a fulfilled promise", function (done) {
        promiseProducer().then(
            function () {
                done();
            },
            function (reason) {
                done(new Error("Expected promise to be fulfilled but it was rejected with " + reason.stack));
            }
        );
    });
};

global.shouldFail = function (options) {
    var promiseProducer = options.op;
    var desiredMessageSubstring = options.message;

    it("should return a promise rejected with an assertion error", function (done) {
        promiseProducer().then(function () {
            done(new Error("Expected promise to be rejected with an assertion error, but it was fulfilled"));
        }, function (reason) {
            if (Object(reason) !== reason || reason.constructor.name !== "AssertionError") {
                done(new Error("Expected promise to be rejected with an AssertionError but it was rejected with " +
                               reason));
            } else {
                if (desiredMessageSubstring && reason.message.indexOf(desiredMessageSubstring) === -1) {
                    done(new Error("Expected promise to be rejected with an AssertionError containing \"" +
                                   desiredMessageSubstring + "\" but it was rejected with " + reason));
                } else {
                    done();
                }
            }
        });
    });
};
