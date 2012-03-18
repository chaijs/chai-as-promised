describe "Promise-specific extensions", ->
    fulfilled = null
    rejected = null

    beforeEach ->
        fulfilled = Q.resolve("foo")
        rejected = Q.reject(new Error())

    describe "fulfilled", ->
        describe "when the target promise is fulfilled", ->
            it "should return a fulfilled promise", (done) ->
                expect(fulfilled.should.be.fulfilled).to.be.fulfilled.then(done, done)

        describe "when the target promise is rejected", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(rejected.should.be.fulfilled).to.be.rejected.with(AssertionError).then(done, done)

    describe "not fulfilled", ->
        describe "when the target promise is fulfilled", ->
            it "should return a promise rejected with an assertion error", (done) ->
                expect(fulfilled.should.not.be.fulfilled).to.be.rejected.with(AssertionError).then(done, done)

        describe "when the target promise is rejected", ->
            it "should return a fulfilled promise", (done) ->
                expect(rejected.should.not.be.fulfilled).to.be.fulfilled.then(done, done)

    testRejected = (name) ->
        describe name, ->
            describe "when the target promise is fulfilled", ->
                it "should return a promise rejected with an assertion error", (done) ->
                    expect(fulfilled.should.be[name]).to.be.rejected.with(AssertionError).then(done, done)

            describe "when the target promise is rejected", ->
                it "should return a fulfilled promise", (done) ->
                    expect(rejected.should.be[name]).to.be.fulfilled.then(done, done)

        describe "not #{ name }", ->
            describe "when the target promise is fulfilled", ->
                it "should return a fulfilled promise", (done) ->
                    expect(fulfilled.should.not.be[name]).to.be.fulfilled.then(done, done)

            describe "when the target promise is rejected", ->
                it "should return a promise rejected with an assertion error", (done) ->
                    expect(rejected.should.not.be[name]).to.be.rejected.with(AssertionError).then(done, done)

        describe "#{ name }.with(Constructor)", ->
            rejectedTypeError = null

            beforeEach ->
                rejectedTypeError = Q.reject(new TypeError())

            describe "when the target promise is fulfilled", ->
                it "should return a promise rejected with an assertion error", (done) ->
                    expect(fulfilled.should.be[name].with(TypeError)).to.be.rejected.with(AssertionError)
                        .then(done, done)

            describe "when the target promise is rejected with a reason having the correct constructor", ->
                it "should return a fulfilled promise", (done) ->
                    expect(rejectedTypeError.should.be[name].with(TypeError)).to.be.fulfilled.then(done, done)

            describe "when the target promise is rejected with a reason having the wrong constructor", ->
                it "should return a promise rejected with an assertion error", (done) ->
                    expect(rejected.should.be[name].with(TypeError)).to.be.rejected.with(AssertionError)
                        .then(done, done)

    testRejected("rejected")
    testRejected("broken")
