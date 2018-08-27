"use strict";
require("./support/setup.js");
const shouldPass = require("./support/common.js").shouldPass;
const shouldFail = require("./support/common.js").shouldFail;
const expect = require("chai").expect;

describe("Promise-specific extensions:", () => {
    let promise = null;
    const error = new Error("boo");
    error.myProp = ["myProp value"];
    const custom = "No. I am your father.";

    function assertingDoneFactory(done) {
        return result => {
            try {
                expect(result).to.equal(error);
            } catch (assertionError) {
                done(assertionError);
            }

            done();
        };
    }

    describe("when the promise is fulfilled", () => {
        beforeEach(() => {
            promise = Promise.resolve(42);
        });

        describe(".fulfilled", () => {
            shouldPass(() => promise.should.be.fulfilled);
        });

        describe(".fulfilled passes the fulfilled value", () => {
            shouldPass(() => promise.should.be.fulfilled.then(passedValue => {
                passedValue.should.equal(42);
            }));
        });

        describe(".fulfilled allows chaining", () => {
            shouldPass(() => promise.should.be.fulfilled.and.eventually.equal(42));
        });

        describe(".not.fulfilled", () => {
            shouldFail({
                op: () => promise.should.not.be.fulfilled,
                message: "not to be fulfilled but it was fulfilled with 42"
            });
        });

        describe(".rejected", () => {
            shouldFail({
                op: () => promise.should.be.rejected,
                message: "to be rejected but it was fulfilled with 42"
            });
        });

        describe(".not.rejected passes the fulfilled value", () => {
            shouldPass(() => promise.should.not.be.rejected.then(passedValue => {
                passedValue.should.equal(42);
            }));
        });

        // .not inverts all following assertions so the following test is
        // equivalent to promise.should.eventually.not.equal(31)
        describe(".not.rejected allows chaining", () => {
            shouldPass(() => promise.should.not.be.rejected.and.eventually.equal(31));
        });

        describe(".rejectedWith(TypeError)", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith(TypeError),
                message: "to be rejected with a TypeError but it was fulfilled with 42"
            });
        });
        describe(".not.rejectedWith(TypeError) passes the fulfilled value", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(TypeError).then(passedValue => {
                passedValue.should.equal(42);
            }));
        });

        describe(".not.rejectedWith(TypeError) allows chaining", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(TypeError).and.eventually.equal(31));
        });

        describe(".rejectedWith('message substring')", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith("message substring"),
                message: "to be rejected with an Error including 'message substring' but it was fulfilled with " +
                         "42"
            });
        });
        describe(".rejectedWith(/regexp/)", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith(/regexp/),
                message: "to be rejected with an Error matching /regexp/ but it was fulfilled with 42"
            });
        });
        describe(".rejectedWith(TypeError, 'message substring')", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith(TypeError, "message substring"),
                message: "to be rejected with a TypeError including 'message substring' but it was fulfilled with 42"
            });
        });
        describe(".rejectedWith(TypeError, /regexp/)", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith(TypeError, /regexp/),
                message: "to be rejected with a TypeError matching /regexp/ but it was fulfilled with 42"
            });
        });
        describe(".rejectedWith(errorInstance)", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith(error),
                message: "to be rejected with [Error: boo] but it was fulfilled with 42"
            });
        });

        describe(".not.rejected", () => {
            shouldPass(() => promise.should.not.be.rejected);
        });
        describe(".not.rejectedWith(TypeError)", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(TypeError));
        });
        describe(".not.rejectedWith('message substring')", () => {
            shouldPass(() => promise.should.not.be.rejectedWith("message substring"));
        });
        describe(".not.rejectedWith(/regexp/)", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(/regexp/));
        });
        describe(".not.rejectedWith(TypeError, 'message substring')", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(TypeError, "message substring"));
        });
        describe(".not.rejectedWith(TypeError, /regexp/)", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(TypeError, /regexp/));
        });
        describe(".not.rejectedWith(errorInstance)", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(error));
        });

        describe(".should.notify(done)", () => {
            it("should pass the test", done => {
                promise.should.notify(done);
            });
        });
    });

    describe("when the promise is rejected", () => {
        beforeEach(() => {
            promise = Promise.reject(error);
        });

        describe(".fulfilled", () => {
            shouldFail({
                op: () => promise.should.be.fulfilled,
                message: "to be fulfilled but it was rejected with [Error: boo]"
            });
        });

        describe(".not.fulfilled", () => {
            shouldPass(() => promise.should.not.be.fulfilled);
        });

        describe(".not.fulfilled should allow chaining", () => {
            shouldPass(() => promise.should.not.be.fulfilled.and.eventually.have.property("nonexistent"));
        });

        describe(".not.fulfilled should pass the rejection reason", () => {
            shouldPass(() => promise.should.not.be.fulfilled.then(passedError => {
                passedError.should.equal(error);
            }));
        });

        describe(".rejected", () => {
            shouldPass(() => promise.should.be.rejected);
        });

        describe(".not.rejected", () => {
            shouldFail({
                op: () => promise.should.not.be.rejected,
                message: "not to be rejected but it was rejected with [Error: boo]"
            });
        });
        describe(".rejected should allow chaining", () => {
            shouldPass(() => promise.should.be.rejected.and.eventually.have.property("myProp"));
        });

        describe(".rejected passes the rejection reason", () => {
            shouldPass(() => promise.should.be.rejected.then(passedError => {
                passedError.should.equal(error);
            }));
        });

        describe(".rejectedWith(theError)", () => {
            shouldPass(() => promise.should.be.rejectedWith(error));
        });

        describe(".not.rejectedWith(theError)", () => {
            shouldFail({
                op: () => promise.should.not.be.rejectedWith(error),
                message: "not to be rejected with [Error: boo]"
            });
        });

        describe(".rejectedWith(theError) should allow chaining", () => {
            shouldPass(() => promise.should.be.rejectedWith(error).and.eventually.have.property("myProp"));
        });

        describe(".rejectedWith(theError) passes the rejection reason", () => {
            shouldPass(() => promise.should.be.rejectedWith(error).then(passedError => {
                passedError.should.equal(error);
            }));
        });

        describe(".rejectedWith(differentError)", () => {
            shouldFail({
                op: () => promise.should.be.rejectedWith(new Error()),
                message: "to be rejected with [Error] but it was rejected with [Error: boo]"
            });
        });

        describe(".not.rejectedWith(differentError)", () => {
            shouldPass(() => promise.should.not.be.rejectedWith(new Error()));
        });

        describe("with an Error having message 'foo bar'", () => {
            beforeEach(() => {
                promise = Promise.reject(new Error("foo bar"));
            });

            describe(".rejectedWith('foo')", () => {
                shouldPass(() => promise.should.be.rejectedWith("foo"));
            });

            describe(".not.rejectedWith('foo')", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith("foo"),
                    message: "not to be rejected with an Error including 'foo'"
                });
            });

            describe(".rejectedWith(/bar/)", () => {
                shouldPass(() => promise.should.be.rejectedWith(/bar/));
            });

            describe(".not.rejectedWith(/bar/)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(/bar/),
                    message: "not to be rejected with an Error matching /bar/"
                });
            });

            describe(".rejectedWith('quux')", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith("quux"),
                    message: "to be rejected with an Error including 'quux' but it was rejected with [Error: foo bar]"
                });
            });

            describe(".not.rejectedWith('quux')", () => {
                shouldPass(() => promise.should.be.not.rejectedWith("quux"));
            });

            describe(".rejectedWith(/quux/)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(/quux/),
                    message: "to be rejected with an Error matching /quux/ but it was rejected with [Error: foo bar]"
                });
            });

            describe(".not.rejectedWith(/quux/)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(/quux/));
            });

            describe(".not.rejectedWith(/bar/, custom)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(/bar/),
                    message: "not to be rejected with an Error matching /bar/ but it was rejected with" +
                             " [Error: foo bar]",
                    notMessage: custom
                });
            });
        });

        describe("with a RangeError", () => {
            beforeEach(() => {
                promise = Promise.reject(new RangeError());
            });

            describe(".rejectedWith(RangeError)", () => {
                shouldPass(() => promise.should.be.rejectedWith(RangeError));
            });

            describe(".not.rejectedWith(RangeError)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError),
                    message: "not to be rejected with a RangeError but it was rejected with [RangeError]"
                });
            });

            describe(".rejectedWith(TypeError)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(TypeError),
                    message: "to be rejected with a TypeError but it was rejected with [RangeError]"
                });
            });

            describe(".not.rejectedWith(TypeError)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError));
            });
        });

        describe("with a RangeError having a message 'foo bar'", () => {
            beforeEach(() => {
                promise = Promise.reject(new RangeError("foo bar"));
            });

            describe(".rejectedWith(RangeError, 'foo')", () => {
                shouldPass(() => promise.should.be.rejectedWith(RangeError, "foo"));
            });

            describe(".not.rejectedWith(RangeError, 'foo')", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, "foo"),
                    message: "not to be rejected with a RangeError including 'foo' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".rejectedWith(RangeError, /bar/)", () => {
                shouldPass(() => promise.should.be.rejectedWith(RangeError, /bar/));
            });

            describe(".not.rejectedWith(RangeError, /bar/)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, /bar/),
                    message: "not to be rejected with a RangeError matching /bar/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".rejectedWith(RangeError, 'quux')", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(RangeError, "quux"),
                    message: "to be rejected with a RangeError including 'quux' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });
            describe(".rejectedWith(RangeError, /quux/)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(RangeError, /quux/),
                    message: "to be rejected with a RangeError matching /quux/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".rejectedWith(TypeError, 'foo')", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(TypeError, "foo"),
                    message: "to be rejected with a TypeError including 'foo' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });
            describe(".rejectedWith(TypeError, /bar/)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(TypeError, /bar/),
                    message: "to be rejected with a TypeError matching /bar/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".rejectedWith(TypeError, 'quux')", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(TypeError, "quux"),
                    message: "to be rejected with a TypeError including 'quux' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });
            describe(".rejectedWith(TypeError, /quux/)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(TypeError, /quux/),
                    message: "to be rejected with a TypeError matching /quux/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".not.rejectedWith(RangeError, 'foo')", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, "foo"),
                    message: "not to be rejected with a RangeError including 'foo' but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });
            describe(".not.rejectedWith(RangeError, /bar/)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, /bar/),
                    message: "not to be rejected with a RangeError matching /bar/ but it was rejected with" +
                             " [RangeError: foo bar]"
                });
            });

            describe(".not.rejectedWith(RangeError, 'quux')", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(RangeError, "quux"));
            });
            describe(".not.rejectedWith(RangeError, /quux/)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(RangeError, /quux/));
            });
            describe(".not.rejectedWith(TypeError, 'foo')", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, "foo"));
            });
            describe(".not.rejectedWith(TypeError, /bar/)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, /bar/));
            });
            describe(".not.rejectedWith(TypeError, 'quux')", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, "quux"));
            });
            describe(".not.rejectedWith(TypeError, /quux/)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, /quux/));
            });
            describe(".rejectedWith(RangeError, 'foo', custom)", () => {
                shouldPass(() => promise.should.be.rejectedWith(RangeError, "foo", custom));
            });

            describe(".not.rejectedWith(RangeError, 'foo', custom)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, "foo", custom),
                    message: custom
                });
            });

            describe(".rejectedWith(RangeError, /bar/, custom)", () => {
                shouldPass(() => promise.should.be.rejectedWith(RangeError, /bar/, custom));
            });

            describe(".not.rejectedWith(RangeError, /bar/, custom)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, /bar/, custom),
                    message: custom
                });
            });

            describe(".rejectedWith(RangeError, 'quux', custom)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(RangeError, "quux", custom),
                    message: custom
                });
            });

            describe(".not.rejectedWith(TypeError, 'quux', custom)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, "quux", custom));
            });

            describe(".rejectedWith(RangeError, /quux/, custom)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(RangeError, /quux/, custom),
                    message: custom
                });
            });

            describe(".not.rejectedWith(TypeError, /quux/, custom)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, /quux/, custom));
            });

            describe(".rejectedWith(RangeError, undefined, custom)", () => {
                shouldPass(() => promise.should.be.rejectedWith(RangeError, undefined, custom));
            });

            describe(".not.rejectedWith(RangeError, undefined, custom)", () => {
                shouldFail({
                    op: () => promise.should.not.be.rejectedWith(RangeError, undefined, custom),
                    message: custom
                });
            });

            describe(".rejectedWith(TypeError, undefined, custom)", () => {
                shouldFail({
                    op: () => promise.should.be.rejectedWith(TypeError, undefined, custom),
                    message: custom
                });
            });

            describe(".not.rejectedWith(TypeError, undefined, custom)", () => {
                shouldPass(() => promise.should.not.be.rejectedWith(TypeError, undefined, custom));
            });
        });

        describe(".should.notify(done)", () => {
            it("should fail the test with the original error", done => {
                promise.should.notify(assertingDoneFactory(done));
            });
        });
    });

    describe(".should.notify with chaining (GH-3)", () => {
        describe("the original promise is fulfilled", () => {
            beforeEach(() => {
                promise = Promise.resolve();
            });

            describe("and the follow-up promise is fulfilled", () => {
                beforeEach(() => {
                    promise = promise.then(() => { /* Do nothing */ });
                });

                it("should pass the test", done => {
                    promise.should.notify(done);
                });
            });

            describe("but the follow-up promise is rejected", () => {
                beforeEach(() => {
                    promise = promise.then(() => {
                        throw error;
                    });
                });

                it("should fail the test with the error from the follow-up promise", done => {
                    promise.should.notify(assertingDoneFactory(done));
                });
            });
        });

        describe("the original promise is rejected", () => {
            beforeEach(() => {
                promise = Promise.reject(error);
            });

            describe("but the follow-up promise is fulfilled", () => {
                beforeEach(() => {
                    promise = promise.then(() => { /* Do nothing */ });
                });

                it("should fail the test with the error from the original promise", done => {
                    promise.should.notify(assertingDoneFactory(done));
                });
            });

            describe("and the follow-up promise is rejected", () => {
                beforeEach(() => {
                    promise = promise.then(() => {
                        throw new Error("follow up");
                    });
                });

                it("should fail the test with the error from the original promise", done => {
                    promise.should.notify(assertingDoneFactory(done));
                });
            });
        });
    });

    describe("Using with non-thenables", () => {
        describe("A number", () => {
            const number = 5;

            it("should fail for .fulfilled", () => {
                expect(() => number.should.be.fulfilled).to.throw(TypeError, "not a thenable");
            });
            it("should fail for .rejected", () => {
                expect(() => number.should.be.rejected).to.throw(TypeError, "not a thenable");
            });
            it("should fail for .become", () => {
                expect(() => number.should.become(5)).to.throw(TypeError, "not a thenable");
            });
            it("should fail for .eventually", () => {
                expect(() => number.should.eventually.equal(5)).to.throw(TypeError, "not a thenable");
            });
            it("should fail for .notify", () => {
                expect(() => number.should.notify(() => { /* Doesn't matter */ }))
                    .to.throw(TypeError, "not a thenable");
            });
        });
    });

    describe("Using together with other Chai as Promised asserters", () => {
        describe(".fulfilled.and.eventually.equal(42)", () => {
            shouldPass(() => Promise.resolve(42).should.be.fulfilled.and.eventually.equal(42));
        });
        describe(".fulfilled.and.rejected", () => {
            shouldFail({
                op: () => Promise.resolve(42).should.be.fulfilled.and.rejected,
                message: "to be rejected but it was fulfilled with 42"
            });
        });

        describe(".rejected.and.eventually.equal(42)", () => {
            shouldPass(() => Promise.reject(42).should.be.rejected.and.eventually.equal(42));
        });
        describe(".rejected.and.become(42)", () => {
            shouldPass(() => Promise.reject(42).should.be.rejected.and.become(42));
        });
    });

    describe("With promises that only become rejected later (GH-24)", () => {
        it("should wait for them", done => {
            let reject;
            const rejectedLaterPromise = new Promise((_, r) => {
                reject = r;
            });
            rejectedLaterPromise.should.be.rejectedWith("error message").and.notify(done);

            setTimeout(() => reject(new Error("error message")), 100);
        });
    });

    describe("when invalid arguments are given to rejectedWith", () => {
        beforeEach(() => {
            promise = Promise.reject(error);
        });

        it("1st arg is a string and 2nd arg is defined", () => {
            expect(() => promise.should.be.rejectedWith("testing", "testing"))
                .to.throw("errMsgMatcher must be null or undefined when errLike is a string or regular expression");
        });

        it("1st arg isn't an `Error` constructor, `Error` instance, string, or regexp", () => {
            expect(() => promise.should.be.rejectedWith({}))
                .to.throw("errLike must be an Error constructor or instance");
        });

        it("2nd arg is defined but not a string or regexp", () => {
            expect(() => promise.should.be.rejectedWith(TypeError, {}))
                .to.throw("errMsgMatcher must be a string or regular expression");
        });

        it("1st arg is an `Error` instance and 2nd arg is defined", () => {
            expect(() => promise.should.be.rejectedWith(error, "testing"))
                .to.throw("errMsgMatcher must be null or undefined when errLike is an Error instance");
        });
    });
});
