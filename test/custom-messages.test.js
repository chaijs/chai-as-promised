const shouldPass = require("./support/common.js").shouldPass;
const shouldFail = require("./support/common.js").shouldFail;

describe("Custom messages", () => {
  let promise = null;
  const message = "He told me enough! He told me you killed him!";

  beforeEach(() => {
    promise = Promise.resolve(42);
  });

  describe("should pass through for .become(value, message) for 42", () => {
    shouldPass(() => promise.should.become(42, message));
  });
  describe("should pass through for .become(value, message) for 52", () => {
    shouldFail({
      op: () => promise.should.become(52, message),
      message
    });
  });

  describe("should pass through for .not.become(42, message)", () => {
    shouldFail({
      op: () => promise.should.not.become(42, message),
      message
    });
  });
  describe("should pass through for .not.become(52, message)", () => {
    shouldPass(() => promise.should.not.become(52, message));
  });

  describe("should pass through for .eventually.equal(42)", () => {
    shouldPass(() => promise.should.eventually.equal(42, message));
  });
  describe("should pass through for .not.eventually.equal(42)", () => {
    shouldFail({
      op: () => promise.should.not.eventually.equal(42, message),
      message
    });
  });
});
