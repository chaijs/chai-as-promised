"use strict";
require("./support/setup.js");
const shouldPass = require("./support/common.js").shouldPass;
const shouldFail = require("./support/common.js").shouldFail;
const assert = require("chai").assert;

describe("Assert interface:", () => {
    let promise = null;
    const error = new Error("boo");
    const custom = "No. I am your father.";

    describe("when the promise is fulfilled", () => {
        beforeEach(() => {
            promise = Promise.resolve({ foo: "bar" });
        });

        describe(".isFulfilled(promise)", () => {
            shouldPass(() => assert.isFulfilled(promise));
        });

        describe(".becomes(promise, correctValue)", () => {
            shouldPass(() => assert.becomes(promise, { foo: "bar" }));
        });
        describe(".becomes(promise, incorrectValue)", () => {
            shouldFail({
                op: () => assert.becomes(promise, { baz: "quux" }),
                message: "to deeply equal { baz: 'quux' }"
            });
        });

        describe(".becomes(promise, incorrectValue, custom)", () => {
            shouldFail({
                op: () => assert.becomes(promise, { baz: "quux" }, custom),
                message: custom
            });
        });

        describe(".doesNotBecome(promise, correctValue)", () => {
            shouldFail({
                op: () => assert.doesNotBecome(promise, { foo: "bar" }),
                message: "to not deeply equal { foo: 'bar' }"
            });
        });
        describe(".doesNotBecome(promise, incorrectValue)", () => {
            shouldPass(() => assert.doesNotBecome(promise, { baz: "quux" }));
        });

        describe(".doesNotBecome(promise, correctValue, custom)", () => {
            shouldFail({
                op: () => assert.doesNotBecome(promise, { foo: "bar" }, custom),
                message: custom
            });
        });

        describe(".isRejected(promise)", () => {
            shouldFail({
                op: () => assert.isRejected(promise),
                message: "to be rejected"
            });
        });
        describe(".isRejected(promise, TypeError)", () => {
            shouldFail({
                op: () => assert.isRejected(promise, TypeError),
                message: "to be rejected"
            });
        });
        describe(".isRejected(promise, /regexp/)", () => {
            shouldFail({
                op: () => assert.isRejected(promise, /regexp/),
                message: "to be rejected"
            });
        });
        describe(".isRejected(promise, TypeError, /regexp/)", () => {
            shouldFail({
                op: () => assert.isRejected(promise, TypeError, /regexp/),
                message: "to be rejected"
            });
        });
        describe(".isRejected(promise, errorInstance)", () => {
            shouldFail({
                op: () => assert.isRejected(promise, error),
                message: "to be rejected"
            });
        });
    });


    describe("when the promise is rejected", () => {
        beforeEach(() => {
            promise = Promise.reject(error);
        });

        describe(".isFulfilled(promise)", () => {
            shouldFail({
                op: () => assert.isFulfilled(promise),
                message: "to be fulfilled"
            });
        });

        describe(".isFulfilled(promise, custom)", () => {
            shouldFail({
                op: () => assert.isFulfilled(promise, custom),
                message: custom
            });
        });

        describe(".isRejected(promise)", () => {
            shouldPass(() => assert.isRejected(promise));
        });

        describe(".isRejected(promise, theError)", () => {
            shouldPass(() => assert.isRejected(promise, error));
        });

        describe(".isRejected(promise, differentError)", () => {
            shouldFail({
                op: () => assert.isRejected(promise, new Error()),
                message: "to be rejected with"
            });
        });

        describe("with an Error having message 'foo bar'", () => {
            beforeEach(() => {
                promise = Promise.reject(new Error("foo bar"));
            });

            describe(".isRejected(promise, 'bar')", () => {
                shouldPass(() => assert.isRejected(promise, "bar"));
            });

            describe(".isRejected(promise, /bar/)", () => {
                shouldPass(() => assert.isRejected(promise, /bar/));
            });

            describe(".isRejected(promise, 'quux')", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, "quux"),
                    message: "to be rejected with"
                });
            });

            describe(".isRejected(promise, /quux/)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, /quux/),
                    message: "to be rejected with"
                });
            });
        });

        describe("with a RangeError", () => {
            beforeEach(() => {
                promise = Promise.reject(new RangeError());
            });

            describe(".isRejected(promise, RangeError)", () => {
                shouldPass(() => assert.isRejected(promise, RangeError));
            });

            describe(".isRejected(promise, TypeError)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, TypeError),
                    message: "to be rejected"
                });
            });
        });

        describe("with a RangeError having a message 'foo bar'", () => {
            beforeEach(() => {
                promise = Promise.reject(new RangeError("foo bar"));
            });

            describe(".isRejected(promise, RangeError, 'foo')", () => {
                shouldPass(() => assert.isRejected(promise, RangeError, "foo"));
            });

            describe(".isRejected(promise, RangeError, /bar/)", () => {
                shouldPass(() => assert.isRejected(promise, RangeError, /bar/));
            });

            describe(".isRejected(promise, RangeError, 'quux')", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, RangeError, "quux"),
                    message: "to be rejected with a RangeError including 'quux' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".isRejected(promise, RangeError, /quux/)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, RangeError, /quux/),
                    message: "to be rejected with a RangeError matching /quux/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".isRejected(promise, TypeError, 'foo')", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, TypeError, "foo"),
                    message: "to be rejected with a TypeError including 'foo' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });
            describe(".isRejected(promise, TypeError, /bar/)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, TypeError, /bar/),
                    message: "to be rejected with a TypeError matching /bar/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".isRejected(promise, TypeError, 'quux')", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, TypeError, "quux"),
                    message: "to be rejected with a TypeError including 'quux' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });
            describe(".isRejected(promise, TypeError, /quux/)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, TypeError, /quux/),
                    message: "to be rejected with a TypeError matching /quux/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".isRejected(promise, RangeError, 'foo', custom)", () => {
                shouldPass(() => assert.isRejected(promise, RangeError, "foo", custom));
            });

            describe(".isRejected(promise, RangeError, /bar/, custom)", () => {
                shouldPass(() => assert.isRejected(promise, RangeError, /bar/, custom));
            });

            describe(".isRejected(promise, RangeError, 'quux', custom)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, RangeError, "quux", custom),
                    message: custom
                });
            });

            describe(".isRejected(promise, RangeError, /quux/, custom)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, RangeError, /quux/, custom),
                    message: custom
                });
            });

            describe(".isRejected(promise, RangeError, undefined, custom)", () => {
                shouldPass(() => assert.isRejected(promise, RangeError, undefined, custom));
            });

            describe(".isRejected(promise, TypeError, undefined, custom)", () => {
                shouldFail({
                    op: () => assert.isRejected(promise, TypeError, undefined, custom),
                    message: custom
                });
            });
        });
    });

    describe("when invalid arguments are given to isRejected", () => {
        beforeEach(() => {
            promise = Promise.reject(error);
        });

        it("2nd arg is a string and 3rd arg is defined", () => {
            assert.throws(
                () => assert.isRejected(promise, "testing", "testing"),
                "errMsgMatcher must be null or undefined when errLike is a string or regular expression"
            );
        });

        it("2nd arg isn't an `Error` constructor, `Error` instance, string, or regexp", () => {
            assert.throws(
                () => assert.isRejected(promise, {}),
                "errLike must be an Error constructor or instance"
            );
        });

        it("3rd arg is defined but not a string or regexp", () => {
            assert.throws(
                () => assert.isRejected(promise, TypeError, {}),
                "errMsgMatcher must be a string or regular expression"
            );
        });

        it("2nd arg is an `Error` instance and 3rd arg is defined", () => {
            assert.throws(
                () => assert.isRejected(promise, error, "testing"),
                "errMsgMatcher must be null or undefined when errLike is an Error instance"
            );
        });
    });
});
