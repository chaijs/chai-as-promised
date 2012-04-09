describe "Assert interface with eventually extender:", ->
    promise = null

    describe "Direct tests of fulfilled promises", ->
        it ".eventually.isNull(promise)", (done) ->
            assert.eventually.isNull(Q.resolve(null)).notify(done)
        it ".eventually.isFunction(promise)", (done) ->
            assert.eventually.isFunction(Q.resolve(->)).notify(done)
        it ".eventually.typeOf(promise, 'string')", (done) ->
            assert.eventually.typeOf(Q.resolve("hello"), "string").notify(done)
        it ".eventually.include(promiseForString, 'substring')", (done) ->
            assert.eventually.include(Q.resolve("hello"), "hell").notify(done)
        it ".eventually.include(promiseForArray, arrayMember)", (done) ->
            assert.eventually.include(Q.resolve([1, 2, 3]), 1).notify(done)

        it ".becomes(true)", (done) ->
            assert.becomes(Q.resolve(true), true).notify(done)
        it ".doesNotBecome(false)", (done) ->
            assert.doesNotBecome(Q.resolve(true), false).notify(done)

    describe "On a promise fulfilled with the number 42", ->
        beforeEach ->
            promise = Q.resolve(42)

        describe ".eventually.isNull(promise)", ->
            shouldFail -> assert.eventually.isNull(promise)
        describe ".eventually.isDefined(promise)", ->
            shouldPass -> assert.eventually.isDefined(promise)
        describe ".eventually.ok(promise)", ->
            shouldPass -> assert.eventually.ok(promise)
        describe ".eventually.equal(promise, 42)", ->
            shouldPass -> assert.eventually.equal(promise, 42)
        describe ".eventually.equal(promise, 52)", ->
            shouldFail -> assert.eventually.equal(promise, 52)
        describe ".eventually.notEqual(promise, 42)", ->
            shouldFail -> assert.eventually.notEqual(promise, 42)
        describe ".eventually.notEqual(promise, 52)", ->
            shouldPass -> assert.eventually.notEqual(promise, 52)

        describe ".becomes(promise, 42)", ->
            shouldPass -> assert.becomes(promise, 42)
        describe ".becomes(promise, 52)", ->
            shouldFail -> assert.becomes(promise, 52)
        describe ".doesNotBecome(promise, 42)", ->
            shouldFail -> assert.doesNotBecome(promise, 42)
        describe ".doesNotBecome(promise, 52)", ->
            shouldPass -> assert.doesNotBecome(promise, 52)

    describe "On a promise fulfilled with { foo: 'bar' }", ->
        beforeEach ->
            promise = Q.resolve(foo: "bar")

        describe ".eventually.equal(promise, { foo: 'bar' })", ->
            shouldFail -> assert.eventually.equal(promise, foo: "bar")
        describe ".eventually.deepEqual(promise, { foo: 'bar' })", ->
            shouldPass -> assert.eventually.deepEqual(promise, foo: "bar")

        describe ".becomes(promise, { foo: 'bar' })", ->
            shouldPass -> assert.becomes(promise, foo: "bar")
        describe ".doesNotBecome(promise, { foo: 'bar' })", ->
            shouldFail -> assert.doesNotBecome(promise, foo: "bar")

    describe "Assertion messages", ->
        message = "He told me enough! He told me you killed him!"

        it "should pass through for .eventually.isNull(promise, message)", ->
            expect(assert.eventually.isNull(Q.resolve(42), message)).to.be.rejected.with(message)
            expect(assert.eventually.isNull(Q.reject(), message)).to.be.rejected.with(message)

        it "should pass through for .eventually.equal(promise, 52, message)", ->
            expect(assert.eventually.equal(Q.resolve(42), 52, message)).to.be.rejected.with(message)
            expect(assert.eventually.equal(Q.reject(), 52, message)).to.be.rejected.with(message)
