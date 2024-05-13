const chai = require("chai");
const chaiAsPromised = require("../../lib/chai-as-promised.js");

chai.should();
chai.use(chaiAsPromised);

process.on("unhandledRejection", () => {
    // Do nothing; we test these all the time.
});
process.on("rejectionHandled", () => {
    // Do nothing; we test these all the time.
});
