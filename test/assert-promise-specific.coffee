"use strict"

describe "Assert interface:", =>
    promise = null
    error = new Error("boo")

    describe "when the promise is fulfilled", =>
        beforeEach =>
            promise = fulfilledPromise(foo: "bar")

        describe ".isFulfilled(promise)", =>
            shouldPass => assert.isFulfilled(promise)

        describe ".becomes(promise, correctValue)", =>
            shouldPass => assert.becomes(promise, foo: "bar")
        describe ".becomes(promise, incorrectValue)", =>
            shouldFail
                op: => assert.becomes(promise, baz: "quux")
                message: "to deeply equal { baz: 'quux' }"

        describe ".doesNotBecome(promise, correctValue)", =>
            shouldFail
                op: => assert.doesNotBecome(promise, foo: "bar")
                message: "to not deeply equal { foo: 'bar' }"
        describe ".doesNotBecome(promise, incorrectValue)", =>
            shouldPass => assert.doesNotBecome(promise, baz: "quux")

        describe ".isRejected(promise)", =>
            shouldFail
                op: => assert.isRejected(promise)
                message: "to be rejected"
        describe ".isRejected(promise, TypeError)", =>
            shouldFail
                op: => assert.isRejected(promise, TypeError)
                message: "to be rejected"
        describe ".isRejected(promise, /regexp/)", =>
            shouldFail
                op: => assert.isRejected(promise, /regexp/)
                message: "to be rejected"
        describe ".isRejected(promise, /regexp/)", =>
            shouldFail
                op: => assert.isRejected(promise, TypeError, /regexp/)
                message: "to be rejected"
        describe ".isRejected(promise, errorInstance)", =>
            shouldFail
                op: => assert.isRejected(promise, error)
                message: "to be rejected"

    describe "when the promise is rejected", =>
        beforeEach =>
            promise = rejectedPromise(error)

        describe ".isFulfilled", =>
            shouldFail
                op: => assert.isFulfilled(promise)
                message: "to be fulfilled"

        describe ".isRejected(promise, theError)", =>
            shouldPass => assert.isRejected(promise, error)

        describe ".isRejected(promise, differentError)", =>
            shouldFail
                op: => assert.isRejected(promise, new Error)
                message: "to be rejected with"

        describe "with an Error having message 'foo bar'", =>
            beforeEach =>
                promise = rejectedPromise(new Error("foo bar"))

            describe ".isRejected(promise, /bar/)", =>
                shouldPass => assert.isRejected(promise, /bar/)

            describe ".isRejected(promise, /quux/)", =>
                shouldFail
                    op: => assert.isRejected(promise, /quux/)
                    message: "to be rejected with"

        describe "with a RangeError", =>
            beforeEach =>
                promise = rejectedPromise(new RangeError)

            describe ".isRejected(promise, RangeError)", =>
                shouldPass => assert.isRejected(promise, RangeError)
            describe ".isRejected(promise, TypeError)", =>
                shouldFail
                    op: => assert.isRejected(promise, TypeError)
                    message: "to be rejected"

    describe "Assertion messages", =>
        message = "No. I am your father."

        describe "should be passed through for .isFulfilled(promise, message)", =>
            shouldFail
                op: => assert.isFulfilled(rejectedPromise(), message)
                message: message

        describe "should be passed through for .isRejected(promise, message)", =>
            shouldFail
                op: => assert.isRejected(fulfilledPromise(), message)
                message: message

        describe "should be passed through for .isRejected(promise, TypeError, message)", =>
            shouldFail
                op: => assert.isRejected(fulfilledPromise(), TypeError, message)
                message: message

        describe "should be passed through for .isRejected(promise, /regexp/, message)", =>
            shouldFail
                op: => assert.isRejected(fulfilledPromise(), /regexp/, message)
                message: message
