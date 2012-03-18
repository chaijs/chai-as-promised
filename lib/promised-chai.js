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

    function property(names, asserter) {
        names.split(" ").forEach(function (name) {
            Object.defineProperty(chai.Assertion.prototype, name, {
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
                                            chai.inspect(value) + ".");
                }

                // Don't return the original value, i.e. swallow fulfillment values so that `.then(done, done)` works.
            }.bind(this),
            function (reason) {
                // If we're in a negated state (i.e. `.not.fulfilled`) then this assertion will get flipped and thus
                // pass, as desired.
                this.assert(false, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                   chai.inspect(reason) + ".");
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
        //     `onTransformedFulfilled` → `this.assert(rejectionReason…, …)` does nothing → fulfills
        // `rejectedWithErrorPromise.should.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason` → fulfills → `with(TypeError)` called →
        //     `onTransformedFulfilled` → `this.assert(rejectionReason…, …)` throws → rejects
        // `rejectedWithTypeErrorPromise.should.not.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason`, `this.assert(true, …)` throws → rejects →
        //     `with(TypeError)` called → `onTransformedRejected` → `this.assert(rejectionReason…, …)` throws →
        //     rejects
        // `rejectedWithErrorPromise.should.not.be.rejected.with(TypeError)`:
        //     `onOriginalRejected` saves `rejectionReason`, `this.assert(true, …)` throws → rejects →
        //     `with(TypeError)` called → `onTransformedRejected` → `this.assert(rejectionReason…, …)` does nothing →
        //     fulfills
        // `fulfilledPromise.should.be.rejected.with(TypeError)`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` throws → rejects → `with(TypeError)` called →
        //     `onTransformedRejected` → `this.assert(false, …)` throws → rejected
        // `fulfilledPromise.should.not.be.rejected.with(TypeError)`:
        //     `onOriginalFulfilled` → `this.assert(false, …)` does nothing → fulfills → `with(TypeError)` called →
        //     `onTransformedFulfilled` → fulfills

        var rejectionReason = null;

        var onOriginalFulfilled = function (value) {
            this.assert(false, "expected " + this.inspect + " to be rejected but it was fulfilled with " +
                               chai.inspect(value) + ".");
        }.bind(this);

        var onOriginalRejected = function (reason) {
            // Store the reason so that `with` can look at it later. Be sure to do this before asserting, since
            // throwing an error from the assert would cancel the process.
            rejectionReason = reason;

            if (this.negate) {
                this.assert(true, null, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                        chai.inspect(reason) + ".");
            }

            // If we didn't throw from the assert, transform rejections into fulfillments, by not re-throwing the
            // reason.
        }.bind(this);

        // Use `Object.create` to ensure we get an extensible promise, so we can add `with`. Q promises, for example,
        // are non-extensible.
        var transformedPromise = Object.create(this.obj.then(onOriginalFulfilled, onOriginalRejected));

        // Augment the transformed promise with a `with` method that performs further transformations.
        transformedPromise.with = function (Constructor) {
            var onTransformedFulfilled = function () {
                if (!this.negate) {
                    this.assert(rejectionReason instanceof Constructor && rejectionReason.name === Constructor.name,
                                "expected " + this.inspect + " to be rejected with " + Constructor.name +
                                " but it was rejected with a " + rejectionReason.name + " instead.");
                }
            }.bind(this);

            var onTransformedRejected = function () {
                if (this.negate) {
                    this.assert(rejectionReason instanceof Constructor && rejectionReason.name === Constructor.name,
                                null,
                                "expected " + this.inspect + " to not be rejected with " + Constructor.name + ".");
                } else {
                    this.assert(false, "expected " + this.inspect + " to be rejected with " + Constructor.name +
                                       " but it was fulfilled instead.");
                }
            }.bind(this);

            return transformedPromise.then(onTransformedFulfilled, onTransformedRejected);
        }.bind(this);

        return transformedPromise;
    });
}));
