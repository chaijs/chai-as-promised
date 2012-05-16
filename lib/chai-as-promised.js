(function (chaiAsPromised) {
    "use strict";

    // Module systems magic dance.

    if (typeof require === "function" && typeof exports === "object" && typeof module === "object") {
        // NodeJS
        module.exports = chaiAsPromised;
    } else if (typeof define === "function" && define.amd) {
        // AMD
        define(function () {
            return chaiAsPromised;
        });
    } else {
        // Other environment (usually <script> tag): plug in to global chai instance directly.
        chai.use(chaiAsPromised);
    }
}(function chaiAsPromised(chai, utils) {
    "use strict";

    var Assertion = chai.Assertion;
    var assert = chai.assert;

    function assertIsAboutPromise(assertion) {
        if (typeof assertion._obj.then !== "function") {
            throw new TypeError(utils.inspect(assertion._obj) + " is not a promise!");
        }
        if (typeof assertion._obj.pipe === "function") {
            throw new TypeError("Chai as Promised is incompatible with jQuery's so-called “promises.” Sorry!");
        }
    }

    function property(name, asserter) {
        utils.addProperty(Assertion.prototype, name, function () {
            assertIsAboutPromise(this);
            return asserter.apply(this, arguments);
        });
    }

    function method(name, asserter) {
        utils.addMethod(Assertion.prototype, name, function () {
            assertIsAboutPromise(this);
            return asserter.apply(this, arguments);
        });
    }

    function notify(promise, callback) {
        return promise.then(function () { callback(); }, callback);
    }

    function addNotifyMethod(extensiblePromise) {
        extensiblePromise.notify = function (callback) {
            return notify(extensiblePromise, callback);
        };
    }

    var fulfilledAsserter = function () {
        var transformedPromise = this._obj.then(
            function (value) {
                if (utils.flag(this, "negate")) {
                    // If we're negated, `this.assert`'s behavior is actually flipped, so `this.assert(true, ...)` will
                    // throw an error, as desired.
                    this.assert(true, null, "expected promise to be rejected but it was fulfilled with " +
                                            utils.inspect(value));
                }

                return value;
            }.bind(this),
            function (reason) {
                // If we're in a negated state (i.e. `.not.fulfilled`) then this assertion will get flipped and thus
                // pass, as desired.
                this.assert(false, "expected promise to be fulfilled but it was rejected with " +
                                   utils.inspect(reason));
            }.bind(this)
        );

        return promiseWithAsserters(transformedPromise, this);
    };

    var rejectedAsserter = function () {
        // THIS SHIT IS COMPLICATED. Best illustrated by exhaustive example.
        ////////////////////////////////////////////////////////////////////
        // `fulfilledPromise.should.be.rejected`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` throws → rejects
        // `fulfilledPromise.should.not.be.rejected`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` does nothing → fulfills
        // `rejectedPromise.should.be.rejected`:
        //     `onOriginalRejected` does nothing relevant → fulfills
        // `rejectedPromise.should.not.be.rejected`:
        //     `onOriginalRejected` → `this.assert(true, …)` throws → rejects
        // `rejectedPromise.should.be.rejected.with(xxx)`:
        //     `onOriginalRejected` saves `rejectionReason` → fulfills →
        //     `with(xxx)` called → `onTransformedFulfilled` → assert about xxx → fulfills/rejects based on asserts
        // `rejectedPromise.should.not.be.rejected.with(xxx)`:
        //     `onOriginalRejected` saves `rejectionReason`, `this.assert(true, …)` throws → rejects →
        //     `with(xxx)` called → `onTransformedRejected` → assert about xxx → fulfills/rejects based on asserts
        // `fulfilledPromise.should.be.rejected.with(xxx)`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` throws → rejects →
        //     `with(xxx)` called → `onTransformedRejected` → `this.assert(false, …)` throws → rejected
        // `fulfilledPromise.should.not.be.rejected.with(xxx)`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` does nothing → fulfills →
        //     `with(xxx)` called → `onTransformedFulfilled` → fulfills

        var rejectionReason = null;

        var onOriginalFulfilled = function (value) {
            this.assert(false, "expected promise to be rejected but it was fulfilled with " + utils.inspect(value));
        }.bind(this);

        var onOriginalRejected = function (reason) {
            // Store the reason so that `with` can look at it later. Be sure to do this before asserting, since
            // throwing an error from the assert would cancel the process.
            rejectionReason = reason;

            if (utils.flag(this, "negate")) {
                this.assert(true, null, "expected promise to be fulfilled but it was rejected with " +
                                        utils.inspect(reason));
            }

            // If we didn't throw from the assert, transform rejections into fulfillments, by not re-throwing the
            // reason.
        }.bind(this);

        var withMethod = function (Constructor, message) {
            var desiredReason = null;

            if (Constructor instanceof RegExp || typeof Constructor === "string") {
                message = Constructor;
                Constructor = null;
            } else if (Constructor && Constructor instanceof Error) {
                desiredReason = Constructor;
                Constructor = null;
                message = null;
            }

            var messageVerb = null;
            var messageIsGood = null;

            if (message instanceof RegExp) {
                messageVerb = "matching";
                messageIsGood = function () {
                    return message.test(rejectionReason.message);
                };
            } else {
                messageVerb = "including";
                messageIsGood = function () {
                    return rejectionReason.message.indexOf(message) !== -1;
                };
            }

            function constructorIsGood() {
                return rejectionReason instanceof Constructor;
            }

            function matchesDesiredReason() {
                return rejectionReason === desiredReason;
            }

            var onTransformedFulfilled = function () {
                if (!utils.flag(this, "negate")) {
                    if (desiredReason) {
                        this.assert(matchesDesiredReason(),
                                    null,
                                    "expected promise to be rejected with " + utils.inspect(desiredReason) + " but " +
                                    "it was rejected with " + utils.inspect(rejectionReason));
                    }

                    if (Constructor) {
                        this.assert(constructorIsGood(),
                                    "expected promise to be rejected with " + Constructor.prototype.name + " but it " +
                                    "was rejected with " + utils.inspect(rejectionReason));
                    }

                    if (message) {
                        this.assert(messageIsGood(),
                                    "expected promise to be rejected with an error " + messageVerb + " " + message +
                                    " but got " + utils.inspect(rejectionReason.message));
                    }
                }
            }.bind(this);

            var onTransformedRejected = function () {
                if (utils.flag(this, "negate")) {
                    if (desiredReason) {
                        this.assert(matchesDesiredReason(),
                                    null,
                                    "expected promise to not be rejected with " + utils.inspect(desiredReason));
                    }

                    if (Constructor) {
                        this.assert(constructorIsGood(),
                                    null,
                                    "expected promise to not be rejected with " + Constructor.prototype.name);
                    }

                    if (message) {
                        this.assert(messageIsGood(),
                                    null,
                                    "expected promise to be not be rejected with an error " + messageVerb + " " +
                                    message);
                    }
                } else {
                    if (desiredReason) {
                        this.assert(false,
                                    "expected promise to be rejected with " + utils.inspect(desiredReason) +
                                    " but it was fulfilled");
                    }

                    if (Constructor) {
                        this.assert(false, "expected promise to be rejected with " + Constructor.prototype.name +
                                           " but it was fulfilled");
                    }

                    if (message) {
                        this.assert(false, "expected promise to be rejected with an error " + messageVerb + " " +
                                           message + " but it was fulfilled");
                    }
                }
            }.bind(this);

            return promiseWithAsserters(transformedPromise.then(onTransformedFulfilled, onTransformedRejected), this);
        }.bind(this);

        var transformedPromise = promiseWithAsserters(this._obj.then(onOriginalFulfilled, onOriginalRejected), this);
        Object.defineProperty(transformedPromise, "with", { enumerable: true, configurable: true, value: withMethod });

        return transformedPromise;
    };

    function promiseWithAsserters(promise, originalAssertion) {
        function makeAssertion(fulfillmentValue) {
            var newAssertion = null;

            if (fulfillmentValue instanceof Assertion) {
                newAssertion = new Assertion(fulfillmentValue._obj);
                utils.flag(newAssertion, "negate", utils.flag(fulfillmentValue, "negate"));
            } else {
                newAssertion = new Assertion(fulfillmentValue);
                utils.flag(newAssertion, "negate", utils.flag(originalAssertion, "negate"));
            }

            return newAssertion;
        }

        function promiseToDoAsserter(doAsserter) {
            var promiseForAssertion = promise.then(makeAssertion);
            var basicPromiseToDoAsserter = promiseForAssertion.then(doAsserter);
            var promiseToDoAsserterWithAsserters = promiseWithAsserters(basicPromiseToDoAsserter, originalAssertion);

            return promiseToDoAsserterWithAsserters;
        }

        // Use `Object.create` to ensure we get an extensible promise, so we can add `with`. Q promises, for example,
        // are non-extensible.
        var augmentedPromise = Object.create(promise);
        var asserterNames = Object.getOwnPropertyNames(Assertion.prototype);
        asserterNames.forEach(function (asserterName) {
            if (["fulfilled", "rejected", "broken", "eventually", "become"].indexOf(asserterName) !== -1) {
                Object.defineProperty(augmentedPromise, asserterName, {
                    get: function () {
                        throw new Error("Cannot use Chai as Promised asserters more than once in an assertion.");
                    }
                });
                return;
            }

            var propertyDescriptor = Object.getOwnPropertyDescriptor(Assertion.prototype, asserterName);

            if (propertyDescriptor.value) {
                propertyDescriptor.value = function () {
                    var args = arguments;

                    return promiseToDoAsserter(function (assertion) {
                        return assertion[asserterName].apply(assertion, args);
                    });
                };
            } else if (propertyDescriptor.get) {
                propertyDescriptor.get = function () {
                    return promiseToDoAsserter(function (assertion) {
                        return assertion[asserterName];
                    });
                };
            }

            Object.defineProperty(augmentedPromise, asserterName, propertyDescriptor);
        });

        addNotifyMethod(augmentedPromise);
        return augmentedPromise;
    }

    property("fulfilled", fulfilledAsserter);
    property("rejected", rejectedAsserter);
    property("broken", rejectedAsserter);

    property("eventually", function () {
        return promiseWithAsserters(this._obj, this);
    });

    method("become", function (value) {
        return this.eventually.eql(value);
    });

    method("notify", function (callback) {
        return notify(this._obj, callback);
    });

    // Now use the Assertion framework to build an `assert` interface.
    var originalAssertMethods = Object.getOwnPropertyNames(assert).filter(function (propName) {
        return typeof assert[propName] === "function";
    });

    assert.isFulfilled = function (promise, message) {
        return (new Assertion(promise, message)).to.be.fulfilled;
    };

    assert.isRejected = assert.isBroken = function (promise, toTestAgainst, message) {
        if (typeof toTestAgainst === "string") {
            message = toTestAgainst;
            toTestAgainst = null;
        }

        var shouldBeRejectedPromise = (new Assertion(promise, message)).to.be.rejected;
        return toTestAgainst ? shouldBeRejectedPromise.with(toTestAgainst) : shouldBeRejectedPromise;
    };

    assert.eventually = {};
    originalAssertMethods.forEach(function (assertMethodName) {
        assert.eventually[assertMethodName] = function (promise) {
            var otherArgs = Array.prototype.slice.call(arguments, 1);

            var promiseToAssert = promise.then(function (fulfillmentValue) {
                return assert[assertMethodName].apply(assert, [fulfillmentValue].concat(otherArgs));
            });

            var augmentedPromiseToAssert = Object.create(promiseToAssert);
            addNotifyMethod(augmentedPromiseToAssert);
            return augmentedPromiseToAssert;
        };
    });

    assert.becomes = function (promise, value) {
        return assert.eventually.deepEqual(promise, value);
    };

    assert.doesNotBecome = function (promise, value) {
        return assert.eventually.notDeepEqual(promise, value);
    };
}));
