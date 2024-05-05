import './support/setup.js';
import {
  default as chaiAsPromised,
  setTransformAsserterArgs
} from '../lib/chai-as-promised.js';

describe('Configuring the way in which asserter arguments are transformed', () => {
  beforeEach(() => {
    setTransformAsserterArgs(Promise.all.bind(Promise));
  });

  afterEach(() => {
    setTransformAsserterArgs(null);
  });

  it('should override transformAsserterArgs and allow to compare promises', () => {
    const value = 'test it';

    return Promise.resolve(value).should.eventually.equal(
      Promise.resolve(value)
    );
  });

  it('should override transformAsserterArgs and wait until all promises are resolved', () => {
    return Promise.resolve(5).should.eventually.be.within(
      Promise.resolve(3),
      Promise.resolve(6)
    );
  });

  it('should not invoke transformAsserterArgs for chai properties', () => {
    chaiAsPromised.transformAsserterArgs = () => {
      throw new Error(
        'transformAsserterArgs should not be called for chai properties'
      );
    };

    return Promise.resolve(true).should.eventually.be.true;
  });

  it('should transform asserter args', () => {
    setTransformAsserterArgs((args) => {
      return Array.from(args).map((x) => x + 1);
    });

    return Promise.resolve(3).should.eventually.equal(2);
  });
});
