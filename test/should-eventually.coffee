"use strict"

describe "Fulfillment value assertions:", =>
    promise = null

    describe "Direct tests of fulfilled promises:", =>
        describe "Basics:", =>
            it ".eventually.equal(42)", (done) =>
                fulfilledPromise(42).should.eventually.equal(42).notify(done)
            it ".eventually.be.arguments", (done) =>
                fulfilledPromise(arguments).should.eventually.be.arguments.notify(done)
            it ".eventually.be.empty", (done) =>
                fulfilledPromise([]).should.eventually.be.empty.notify(done)
            it ".eventually.exist", (done) =>
                fulfilledPromise(true).should.eventually.exist.notify(done)
            it ".eventually.be.false", (done) =>
                fulfilledPromise(false).should.eventually.be.false.notify(done)
            it ".eventually.be.ok", (done) =>
                fulfilledPromise({}).should.eventually.be.ok.notify(done)
            it ".eventually.be.true", (done) =>
                fulfilledPromise(true).should.eventually.be.true.notify(done)
            it ".become(true)", (done) =>
                fulfilledPromise(true).should.become(true).notify(done)

        describe "With flags and chainable methods involved:", =>
            it ".not.eventually.be.ok", (done) =>
                fulfilledPromise(false).should.not.eventually.be.ok.notify(done)
            it ".eventually.not.be.ok", (done) =>
                fulfilledPromise(false).should.eventually.not.be.ok.notify(done)
            it ".eventually.deep.equal({ foo: 'bar' })", (done) =>
                fulfilledPromise(foo: "bar").should.eventually.deep.equal(foo: "bar").notify(done)
            it ".not.eventually.deep.equal({ foo: 'bar' })", (done) =>
                fulfilledPromise(foo: "baz").should.not.eventually.deep.equal(foo: "bar").notify(done)
            it ".eventually.not.deep.equal({ foo: 'bar' })", (done) =>
                fulfilledPromise(foo: "baz").should.eventually.not.deep.equal(foo: "bar").notify(done)
            it ".eventually.have.deep.property('foo.bar')", (done) =>
                fulfilledPromise(foo: bar: "baz").should.eventually.have.deep.property("foo.bar", "baz").notify(done)
            it ".eventually.contain('foo')", (done) =>
                fulfilledPromise(["foo", "bar"]).should.eventually.contain("foo").notify(done)
            it ".not.eventually.contain('foo')", (done) =>
                fulfilledPromise(["bar", "baz"]).should.not.eventually.contain("foo").notify(done)
            it ".eventually.not.contain('foo')", (done) =>
                fulfilledPromise(["bar", "baz"]).should.eventually.not.contain("foo").notify(done)
            it ".eventually.contain.keys('foo')", (done) =>
                fulfilledPromise(foo: "bar", baz: "quux").should.eventually.contain.keys("foo").notify(done)
            it ".not.eventually.contain.keys('foo')", (done) =>
                fulfilledPromise(baz: "quux").should.not.eventually.contain.keys("foo").notify(done)
            it ".eventually.not.contain.keys('foo')", (done) =>
                fulfilledPromise(baz: "quux").should.eventually.not.contain.keys("foo").notify(done)
            it ".eventually.be.an.instanceOf(Array)", (done) =>
                fulfilledPromise([]).should.eventually.be.an.instanceOf(Array).notify(done)

    describe "Chaining:", =>
        it ".eventually.be.ok.and.equal(42)", (done) =>
            fulfilledPromise(42).should.eventually.be.ok.and.equal(42).notify(done)
        it ".rejected.and.notify(done)", (done) =>
            rejectedPromise().should.be.rejected.and.notify(done)
        it ".fulfilled.and.notify(done)", (done) =>
            fulfilledPromise().should.be.fulfilled.and.notify(done)

    describe "On a promise fulfilled with the number 42:", =>
        beforeEach =>
            promise = fulfilledPromise(42)

        describe ".eventually.equal(42)", =>
            shouldPass => promise.should.eventually.equal(42)
        describe ".eventually.eql(42)", =>
            shouldPass => promise.should.eventually.eql(42)
        describe ".eventually.be.below(9000)", =>
            shouldPass => promise.should.eventually.be.below(9000)
        describe ".eventually.be.a('number')", =>
            shouldPass => promise.should.eventually.be.a("number")

        describe ".eventually.be.an.instanceOf(String)", =>
            shouldFail
                op: => promise.should.eventually.be.an.instanceOf(String)
                message: "42 to be an instance of String"
        describe ".eventually.be.false", =>
            shouldFail
                op: => promise.should.eventually.be.false
                message: "to be false"
        describe ".eventually.be.an('object')", =>
            shouldFail
                op: => promise.should.eventually.be.an("object")
                message: "to be an object"


        ###
        describe ".eventually.not.equal(52)", =>
            shouldPass => promise.should.eventually.not.equal(52)
        describe ".not.eventually.equal(52)", =>
            shouldPass => promise.should.not.eventually.equal(52)

        describe ".eventually.not.equal(42)", =>
            shouldFail => promise.should.eventually.not.equal(42)
        describe ".not.eventually.equal(42)", =>
            shouldFail => promise.should.not.eventually.equal(42)

        describe ".become(42)", =>
            shouldPass => promise.should.become(42)
        describe ".become(52)", =>
            shouldFail => promise.should.become(52)

        describe ".not.become(42)", =>
            shouldFail => promise.should.not.become(42)
        describe ".not.become(52)", =>
            shouldPass => promise.should.not.become(52)
        ###

    describe "On a promise fulfilled with { foo: 'bar' }:", =>
        beforeEach =>
            promise = fulfilledPromise(foo: "bar")

        describe ".eventually.equal({ foo: 'bar' })", =>
            shouldFail
                op: => promise.should.eventually.equal(foo: "bar")
                message: "to equal { foo: 'bar' }"
        describe ".eventually.eql({ foo: 'bar' })", =>
            shouldPass => promise.should.eventually.eql(foo: "bar")
        describe ".eventually.deep.equal({ foo: 'bar' })", =>
            shouldPass => promise.should.eventually.deep.equal(foo: "bar")
        describe ".eventually.not.deep.equal({ foo: 'bar' })", =>
            shouldFail
                op: => promise.should.eventually.not.deep.equal(foo: "bar")
                message: "not deeply equal { foo: 'bar' }"
        describe ".eventually.deep.equal({ baz: 'quux' })", =>
            shouldFail
                op: => promise.should.eventually.deep.equal(baz: "quux")
                message: "deeply equal { baz: 'quux' }"
        describe ".eventually.not.deep.equal({ baz: 'quux' })", =>
            shouldPass => promise.should.eventually.not.deep.equal(baz: "quux")
        describe ".become({ foo: 'bar' })", =>
            shouldPass => promise.should.become(foo: "bar")
        describe ".not.become({ foo: 'bar' })", =>
            shouldFail
                op: => promise.should.not.become(foo: "bar")
                message: "deeply equal { foo: 'bar' }"

        describe ".eventually.have.property('foo').that.equals('bar')", =>
            shouldPass => promise.should.eventually.have.property('foo').that.equals('bar')
