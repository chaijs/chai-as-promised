describe "Promise-specific extensions", ->
    fulfilled = null
    rejected = null

    beforeEach ->
        fulfilled = Q.resolve("foo")
        rejected = Q.reject(new Error())

    describe "fulfilled", ->
        it "should return a fulfilled promise when the target promise is fulfilled", (done) ->
            expect(fulfilled.should.be.fulfilled).to.be.fulfilled.then(done, done);

        it "should return a promise rejected with an assertion error when the target promise is rejected", (done) ->
            expect(rejected.should.be.fulfilled).to.be.rejected.with(AssertionError).then(done, done);

        it "should be usable with `.then(done, done)`", (done) ->
            fulfilled.should.be.fulfilled.then(done, done)

    describe "not fulfilled", ->
        it "should return a fulfilled promise when the target promise is rejected", (done) ->
            expect(rejected.should.not.be.fulfilled).to.be.fulfilled.then(done, done);

        it "should return a promise rejected with an assertion error when the target promise is fulfilled", (done) ->
            expect(fulfilled.should.not.be.fulfilled).to.be.rejected.with(AssertionError).then(done, done);

    testRejected = (name) ->
        describe name, ->
            it "should return a fulfilled promise when the target promise is rejected", (done) ->
                expect(rejected.should.be[name]).to.be.fulfilled.then(done, done);

            it "should return a promise rejected with an assertion error when the target promise is fulfilled", (done) ->
                expect(fulfilled.should.be[name]).to.be.rejected.with(AssertionError).then(done, done);

        describe "not #{ name }", ->
            it "should return a fulfilled promise when the target promise is fulfilled", (done) ->
                expect(fulfilled.should.not.be[name]).to.be.fulfilled.then(done, done);

            it "should return a promise rejected with an assertion error when the target promise is rejected", (done) ->
                expect(rejected.should.not.be[name]).to.be.rejected.with(AssertionError).then(done, done);

        describe "#{ name }.with(Constructor)", ->
            rejectedTypeError = null

            beforeEach ->
                rejectedTypeError = Q.reject(new TypeError())

            it "should return a fulfilled promise when the target promise is rejected with a reason having the correct " +
               "constructor", (done) ->
                expect(rejectedTypeError.should.be[name].with(TypeError)).to.be.fulfilled.then(done, done);

            it "should return a promise rejected with an assertion error when the target promise is rejected with a " +
               "reason having the wrong constructor", (done) ->
                expect(rejected.should.be[name].with(TypeError)).to.be.rejected.with(AssertionError).then(done, done);

    testRejected("rejected")
    testRejected("broken")
