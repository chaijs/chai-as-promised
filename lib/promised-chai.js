(function (promisedChai) {
    "use strict";

    // Module systems magic dance.

    if (typeof require === "function" && typeof exports === "object" && typeof module === "object") {
        // NodeJS
        module.exports = promisedChai;
    } else if (typeof define === "function" && define.amd) {
        // AMD
        define(function () {
            return promisedChai;
        });
    } else {
        // Other environment (usually <script> tag): attach to global.
        var global = (false || eval)("this");
        global.promisedChai = promisedChai;
    }
}(function promisedChai(chai) {
    "use strict";

    var Assertion = chai.Assertion;

    function property(names, asserter) {
        names.split(" ").forEach(function (name) {
            Object.defineProperty(Assertion.prototype, name, {
                get: asserter,
                configurable: true
            });
        });
    }

    property("fulfilled", function () {
        return this.obj.then(
            function (value) {
                if (this.negate) {
                    // If we're negated, `this.assert`'s behavior is actually flipped, so `this.assert(true, ...)` will
                    // throw an error, as desired.
                    this.assert(true, null, "expected " + this.inspect + " to be rejected but it was fulfilled with " +
                                            chai.inspect(value));
                }

                // Don't return the original value, i.e. swallow fulfillment values so that `.then(done, done)` works.
            }.bind(this),
            function (reason) {
                // If we're in a negated state (i.e. `.not.fulfilled`) then this assertion will get flipped and thus
                // pass, as desired.
                this.assert(false, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                   chai.inspect(reason));
            }.bind(this)
        );
    });

    property("rejected broken", function () {
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
        // `rejectedWithTypeErrorPromise.should.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason` → fulfills → `with(TypeError)` called →
        //     `onTransformedFulfilled` → `this.assert(constructorIsGood(), …)` does nothing → fulfills
        // `rejectedWithErrorPromise.should.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason` → fulfills → `with(TypeError)` called →
        //     `onTransformedFulfilled` → `this.assert(constructorIsGood(), …)` throws → rejects
        // `rejectedWithTypeErrorPromise.should.not.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason`, `this.assert(true, …)` throws → rejects →
        //     `with(TypeError)` called → `onTransformedRejected` → `this.assert(constructorIsGood(), …)` throws →
        //     rejects
        // `rejectedWithErrorPromise.should.not.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason`, `this.assert(true, …)` throws → rejects →
        //     `with(TypeError)` called → `onTransformedRejected` →
        //     `this.assert(constructorIsGood(), …)` does nothing → fulfills
        // `fulfilledPromise.should.be.rejected.with(TypeError)`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` throws → rejects → `with(TypeError)` called →
        //     `onTransformedRejected` → `this.assert(false, …)` throws → rejected
        // `fulfilledPromise.should.not.be.rejected.with(TypeError)`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` does nothing → fulfills → `with(TypeError)` called →
        //     `onTransformedFulfilled` → fulfills

        var rejectionReason = null;

        var onOriginalFulfilled = function (value) {
            this.assert(false, "expected " + this.inspect + " to be rejected but it was fulfilled with " +
                               chai.inspect(value));
        }.bind(this);

        var onOriginalRejected = function (reason) {
            // Store the reason so that `with` can look at it later. Be sure to do this before asserting, since
            // throwing an error from the assert would cancel the process.
            rejectionReason = reason;

            if (this.negate) {
                this.assert(true, null, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                        chai.inspect(reason));
            }

            // If we didn't throw from the assert, transform rejections into fulfillments, by not re-throwing the
            // reason.
        }.bind(this);

        // Use `Object.create` to ensure we get an extensible promise, so we can add `with`. Q promises, for example,
        // are non-extensible.
        var transformedPromise = Object.create(this.obj.then(onOriginalFulfilled, onOriginalRejected));

        // Augment the transformed promise with a `with` method that performs further transformations.
        transformedPromise.with = function (Constructor, message) {
            if (Constructor instanceof RegExp || typeof Constructor === "string") {
                message = Constructor;
                Constructor = null;
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
                return rejectionReason instanceof Constructor && rejectionReason.name === Constructor.name;
            }

            var onTransformedFulfilled = function () {
                if (!this.negate) {
                    if (Constructor) {
                        this.assert(constructorIsGood(),
                                    "expected " + this.inspect + " to be rejected with " + Constructor.name +
                                    " but it was rejected with " + chai.inspect(rejectionReason));
                    }

                    if (message) {
                        this.assert(messageIsGood(),
                                    "expected " + this.inspect + " to be rejected with an error " + messageVerb + " " +
                                    message + " but got " + chai.inspect(rejectionReason.message));
                    }
                }
            }.bind(this);

            var onTransformedRejected = function () {
                if (this.negate) {
                    if (Constructor) {
                        this.assert(constructorIsGood(),
                                    null,
                                    "expected " + this.inspect + " to not be rejected with " + Constructor.name);
                    }

                    if (message) {
                        this.assert(messageIsGood(),
                                    null,
                                    "expected " + this.inspect + " to be not be rejected with an error " + messageVerb +
                                    " " + message);
                    }
                } else {
                    if (Constructor) {
                        this.assert(false, "expected " + this.inspect + " to be rejected with " + Constructor.name +
                                           " but it was fulfilled");
                    }

                    if (message) {
                        this.assert(false, "expected " + this.inspect + " to be rejected with an error " + messageVerb +
                                           " " + message + " but it was fulfilled");
                    }
                }
            }.bind(this);

            return transformedPromise.then(onTransformedFulfilled, onTransformedRejected);
        }.bind(this);

        return transformedPromise;
    });

    function promiseWithAsserters(originalPromise) {
        var promise = Object.create(originalPromise);

        var asserterNames = Object.getOwnPropertyNames(Assertion.prototype);
        asserterNames.forEach(function (asserterName) {
            var propertyDescriptor = Object.getOwnPropertyDescriptor(Assertion.prototype, asserterName);

            if (propertyDescriptor.value) {
                propertyDescriptor.value = function () {
                    var args = arguments;
                    return promiseWithAsserters(promise.then(function (value) {
                        var assertion = new Assertion(value instanceof Assertion ? value.obj : value);
                        return assertion[asserterName].apply(assertion, args);
                    }));
                };
            } else if (propertyDescriptor.get) {
                propertyDescriptor.get = function () {
                    return promiseWithAsserters(promise.then(function (value) {
                        var assertion = new chai.Assertion(value instanceof Assertion ? value.obj : value);
                        return assertion[asserterName];
                    }));
                };
            }

            Object.defineProperty(promise, asserterName, propertyDescriptor);
        });

        return promise;
    }

    property("eventually", function () {
        return promiseWithAsserters(this.obj);
    });
}));
