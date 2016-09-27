"use strict";

exports.shouldPass = function (promiseProducer) {
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

exports.shouldFail = function (options) {
    var promiseProducer = options.op;
    var desiredMessageSubstring = options.message;
    var nonDesiredMessageSubstring = options.notMessage;

    it("should return a promise rejected with an assertion error", function (done) {
        promiseProducer().then(function () {
            throw new Error("Expected promise to be rejected with an assertion error, but it was fulfilled");
        }, function (reason) {
            if (Object(reason) !== reason || reason.constructor.name !== "AssertionError") {
                throw new Error("Expected promise to be rejected with an AssertionError but it was rejected with " +
                                reason);
            }

            if (desiredMessageSubstring && reason.message.indexOf(desiredMessageSubstring) === -1) {
                throw new Error("Expected promise to be rejected with an AssertionError containing \"" +
                                desiredMessageSubstring + "\" but it was rejected with " + reason);
            }

            if (nonDesiredMessageSubstring && reason.message.indexOf(nonDesiredMessageSubstring) !== -1) {
                throw new Error("Expected promise to be rejected with an AssertionError not containing \"" +
                                nonDesiredMessageSubstring + "\" but it was rejected with " + reason);
            }
        }).then(done, done);

    });
};
