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
            function () { }, // Swallow fulfillment values so that `.then(done, done)` works.
            function (error) {
                this.assert(false, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                   chai.inspect(error) + ".");
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
                // Transform rejections into fulfillments, but store the reason so that `with` can look at it later.
                rejectionReason = reason;
            }
        ));

        // Augment the returned promise with a `with` method that checks the property of the rejection reason.
        returnedPromise.with = function (Constructor) {
            return returnedPromise.then(function () {
                // Note that we only get here if `returnedPromise` is fulfilled, i.e. if `this.obj` was rejected.
                this.assert(rejectionReason instanceof Constructor && rejectionReason.name === Constructor.name,
                            "expected " + this.inspect + " to be rejected with " + Constructor.name +
                            " but it was rejected with a " + reason.name + " instead.",
                            "expected " + this.inspect + " to not be rejected with " + Constructor.name);
            });
        }.bind(this);

        return returnedPromise;
    });
}));
