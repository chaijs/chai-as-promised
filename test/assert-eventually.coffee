"use strict"

describe "Assert interface with eventually extender:", =>
    promise = null

    describe "Direct tests of fulfilled promises", =>
        it ".eventually.isNull(promise)", (done) =>
            assert.eventually.isNull(fulfilledPromise(null)).notify(done)
        it ".eventually.isFunction(promise)", (done) =>
            assert.eventually.isFunction(fulfilledPromise(=>)).notify(done)
        it ".eventually.typeOf(promise, 'string')", (done) =>
            assert.eventually.typeOf(fulfilledPromise("hello"), "string").notify(done)
        it ".eventually.include(promiseForString, 'substring')", (done) =>
            assert.eventually.include(fulfilledPromise("hello"), "hell").notify(done)
        it ".eventually.include(promiseForArray, arrayMember)", (done) =>
            assert.eventually.include(fulfilledPromise([1, 2, 3]), 1).notify(done)

    describe "On a promise fulfilled with the number 42", =>
        beforeEach =>
            promise = fulfilledPromise(42)

        describe ".eventually.isNull(promise)", =>
            shouldFail
                op: => assert.eventually.isNull(promise)
                message: "to equal null"
        describe ".eventually.isDefined(promise)", =>
            shouldPass => assert.eventually.isDefined(promise)
        describe ".eventually.ok(promise)", =>
            shouldPass => assert.eventually.ok(promise)
        describe ".eventually.equal(promise, 42)", =>
            shouldPass => assert.eventually.equal(promise, 42)
        describe ".eventually.equal(promise, 52)", =>
            shouldFail
                op: => assert.eventually.equal(promise, 52)
                message: "to equal 52"

            shouldFailWithCorrectActual = (promiseProducer) =>
                it "should return a promise rejected with an assertion error that has actual/expected properties " +
                   "correct", (done) =>
                    expect(promiseProducer().then(
                        =>
                            throw new Error("promise fulfilled")
                        (e) =>
                            e.actual.should.equal(42)
                            e.expected.should.equal(52)
                    )).to.be.fulfilled.notify(done)

            describe "assert", =>
                shouldFailWithCorrectActual => assert.eventually.equal(promise, 52)
            describe "expect", =>
                shouldFailWithCorrectActual => expect(promise).to.eventually.equal(52)
            describe "should", =>
                shouldFailWithCorrectActual => promise.should.eventually.equal(52)

        describe ".eventually.notEqual(promise, 42)", =>
            shouldFail
                op: => assert.eventually.notEqual(promise, 42)
                message: "to not equal 42"
        describe ".eventually.notEqual(promise, 52)", =>
            shouldPass => assert.eventually.notEqual(promise, 52)

    describe "On a promise fulfilled with { foo: 'bar' }", =>
        beforeEach =>
            promise = fulfilledPromise(foo: "bar")

        describe ".eventually.equal(promise, { foo: 'bar' })", =>
            shouldFail
                op: => assert.eventually.equal(promise, foo: "bar")
                message: "to equal { foo: 'bar' }"
        describe ".eventually.deepEqual(promise, { foo: 'bar' })", =>
            shouldPass => assert.eventually.deepEqual(promise, foo: "bar")

    describe "Assertion messages", =>
        message = "He told me enough! He told me you killed him!"

        describe "should pass through for .eventually.isNull(promise, message) for fulfilled", (done) =>
            shouldFail
                op: => assert.eventually.isNull(fulfilledPromise(42), message)
                message: message

        describe "should pass through for .eventually.isNull(promise, message) for rejected", (done) =>
            shouldFail
                op: => assert.eventually.isNull(rejectedPromise(), message)
                message: message

        describe "should pass through for .eventually.equal(promise, 52, message) for fulfilled", (done) =>
            shouldFail
                op: => assert.eventually.equal(fulfilledPromise(42), 52, message)
                message: message

        describe "should pass through for .eventually.equal(promise, 52, message) for rejected", (done) =>
            shouldFail
                op: => assert.eventually.equal(rejectedPromise(), 52, message)
                message: message
