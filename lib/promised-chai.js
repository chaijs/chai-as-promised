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

    function property(name, asserter) {
        Object.defineProperty(chai.Assertion.prototype, name, {
            get: asserter,
            configurable: true
        });
    }

    property("fulfilled", function () {
        return this.obj.then(
            null, // pass through fulfillment
            function (error) {
                this.assert(false, "expected " + this.inspect + " to be fulfilled but it was rejected with " +
                                   chai.inspect(error) + ".");
            }.bind(this)
        );
    });

    property("rejected", function () {
        return this.obj.then(
            function (value) {
                this.assert(false, "expected " + this.inspect + " to be rejected but it was fulfilled with " +
                                   chai.inspect(value) + ".");
            }.bind(this),
            function () { } // swallow rejections
        );
    });
}));
