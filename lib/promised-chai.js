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

}));