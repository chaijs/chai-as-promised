shouldPass = (promiseProducer) ->
    it "should return a fulfilled promise", (done) ->
        expect(promiseProducer()).to.be.fulfilled.then(done, done)

shouldFail = (promiseProducer) ->
    it "should return a promise rejected with an assertion error", (done) ->
        expect(promiseProducer()).to.be.rejected.with(AssertionError).then(done, done)

describe "Fulfillment value assertions:", ->
    promise = null

    describe "On a promise fulfilled with the number 42", ->
        beforeEach ->
            promise = Q.resolve(42)

        describe ".eventually.equal(42)", ->
            shouldPass -> promise.should.eventually.equal(42)
        describe ".eventually.eql(42)", ->
            shouldPass -> promise.should.eventually.eql(42)
        describe ".eventually.be.below(9000)", ->
            shouldPass -> promise.should.eventually.be.below(9000)

        describe ".eventually.be.an.instanceOf(String)", ->
            shouldFail -> promise.should.eventually.be.an.instanceOf(String)
        describe ".eventually.be.false", ->
            shouldFail -> promise.should.eventually.be.false


        describe ".eventually.not.equal(52)", ->
            shouldPass -> promise.should.eventually.not.equal(52)
        describe ".not.eventually.equal(52)", ->
            shouldPass -> promise.should.not.eventually.equal(52)

        describe ".eventually.not.equal(42)", ->
            shouldFail -> promise.should.eventually.not.equal(42)
        describe ".not.eventually.equal(42)", ->
            shouldFail -> promise.should.not.eventually.equal(42)

        describe ".become(42)", ->
            shouldPass -> promise.should.become(42)
        describe ".become(52)", ->
            shouldFail -> promise.should.become(52)

        describe ".not.become(42)", ->
            shouldFail -> promise.should.not.become(42)
        describe ".not.become(52)", ->
            shouldPass -> promise.should.not.become(52)

    describe "On a promise fulfilled with { foo: 'bar' }", ->
        beforeEach ->
            promise = Q.resolve(foo: "bar")

        describe ".eventually.equal({ foo: 'bar' })", ->
            shouldFail -> promise.should.eventually.equal(foo: "bar")
        describe ".eventually.eql({ foo: 'bar' })", ->
            shouldPass -> promise.should.eventually.eql(foo: "bar")
        describe ".become({ foo: 'bar' })", ->
            shouldPass -> promise.should.become(foo: "bar")
        describe ".not.become({ foo: 'bar' })", ->
            shouldFail -> promise.should.not.become(foo: "bar")
