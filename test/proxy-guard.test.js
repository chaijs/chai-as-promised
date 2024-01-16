chai.should();
chai.use(chaiAsPromised);

function shouldGuard(fn, msg) {
  fn.should.throw("Invalid Chai property: " + msg);
}

describe("Proxy guard", () => {
  const number = 42;
  const promise = Promise.resolve(42);

  before(function () {
    if (typeof Proxy === "undefined" || typeof Reflect === "undefined" || chai.util.proxify === undefined) {
      /* eslint-disable no-invalid-this */
      this.skip();
      /* eslint-enable no-invalid-this */
    }
  });

  it("should guard against invalid property following `.should`", () => {
    shouldGuard(() => number.should.pizza, "pizza");
  });

  it("should guard against invalid property following overwritten language chain", () => {
    shouldGuard(() => number.should.to.pizza, "pizza");
  });

  it("should guard against invalid property following overwritten property assertion", () => {
    shouldGuard(() => number.should.ok.pizza, "pizza");
  });

  it("should guard against invalid property following uncalled overwritten method assertion", () => {
    shouldGuard(() => number.should.equal.pizza, "equal.pizza. See docs");
  });

  it("should guard against invalid property following called overwritten method assertion", () => {
    shouldGuard(() => number.should.equal(number).pizza, "pizza");
  });

  it("should guard against invalid property following uncalled overwritten chainable method assertion", () => {
    shouldGuard(() => number.should.a.pizza, "pizza");
  });

  it("should guard against invalid property following called overwritten chainable method assertion", () => {
    shouldGuard(() => number.should.a("number").pizza, "pizza");
  });

  it("should guard against invalid property following `.eventually`", () => {
    shouldGuard(() => promise.should.eventually.pizza, "pizza");
  });

  it("should guard against invalid property following `.fulfilled`", () => {
    shouldGuard(() => promise.should.fulfilled.pizza, "pizza");
  });

  it("should guard against invalid property following `.rejected`", () => {
    shouldGuard(() => promise.should.rejected.pizza, "pizza");
  });

  it("should guard against invalid property following called `.rejectedWith`", () => {
    shouldGuard(() => promise.should.rejectedWith(42).pizza, "pizza");
  });

  it("should guard against invalid property following uncalled `.rejectedWith`", () => {
    shouldGuard(() => promise.should.rejectedWith.pizza, "rejectedWith.pizza. See docs");
  });

  it("should guard against invalid property following called `.become`", () => {
    shouldGuard(() => promise.should.become(42).pizza, "pizza");
  });

  it("should guard against invalid property following uncalled `.become`", () => {
    shouldGuard(() => promise.should.become.pizza, "become.pizza. See docs");
  });
});
