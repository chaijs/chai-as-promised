import * as chai from "chai";
import chaiAsPromised from "../../lib/chai-as-promised.js";

chai.should();
chai.use(chaiAsPromised);

global.chai = chai;
global.expect = chai.expect;
global.assert = chai.assert;
global.chaiAsPromised = chaiAsPromised;

process.on("unhandledRejection", () => {
  // Do nothing; we test these all the time.
});
process.on("rejectionHandled", () => {
  // Do nothing; we test these all the time.
});
