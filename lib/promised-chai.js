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
                    this.assert(true, "expected " + this.inspect + " to be rejected but it was fulfilled with " +
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
        var rejectionReason = null;

        // Use `Object.create` to ensure we get an extensible promise, so we can add `with`. Q promises, for example,
        // are non-extensible.
        var returnedPromise = Object.create(this.obj.then(
            function (value) {
                this.assert(false, "expected " + this.inspect + " to be rejected but it was fulfilled with " +
                                   chai.inspect(value) + ".");
            }.bind(this),
            function (reason) {
                if (this.negate) {
                    // If we're negated, `this.assert`'s behavior is actually flipped, so `this.assert(true, ...)` will
                    // throw an error, as desired.
                    this.assert(true, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                      chai.inspect(reason) + ".");
                }

                // Store the reason so that `with` can look at it later.
                rejectionReason = reason;

                // Transform rejections into fulfillments, by not re-throwing the reason.
            }.bind(this)
        ));

        // Augment the returned promise with a `with` method that checks the property of the rejection reason.
        returnedPromise.with = function (Constructor) {
            return returnedPromise.then(function () {
                // Note that we only get here if `returnedPromise` is fulfilled, i.e. if `this.obj` was rejected.
                this.assert(rejectionReason instanceof Constructor && rejectionReason.name === Constructor.name,
                            "expected " + this.inspect + " to be rejected with " + Constructor.name +
                            " but it was rejected with a " + rejectionReason.name + " instead.",
                            "expected " + this.inspect + " to not be rejected with " + Constructor.name);
            }.bind(this));
        }.bind(this);

        return returnedPromise;
    });
}));
