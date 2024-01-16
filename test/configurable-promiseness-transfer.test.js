const originalTransferPromiseness = chaiAsPromised.transferPromiseness;

describe("Configuring the way in which promise-ness is transferred", () => {
  afterEach(() => {
    chaiAsPromised.transferPromiseness = originalTransferPromiseness;
  });

  it("should return a promise with the custom modifications applied", () => {
    chaiAsPromised.transferPromiseness = (assertion, promise) => {
      assertion.then = promise.then.bind(promise);
      assertion.isCustomized = true;
    };

    const promise = Promise.resolve("1234");
    const assertion = promise.should.become("1234");

    assertion.should.have.property("isCustomized", true);
  });
});
