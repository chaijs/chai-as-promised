global.shouldPass = function (promiseProducer) {
    it("should return a fulfilled promise", function (done) {
        expect(promiseProducer()).to.be.fulfilled.notify(done);
    });
};

global.shouldFail = function (promiseProducer) {
    it("should return a promise rejected with an assertion error", function (done) {
        expect(promiseProducer()).to.be.rejected.with(AssertionError).notify(done);
    });
};
