'use babel';
import linkPaths from '../lib/link-paths';

describe('linkPaths', function() {
  it('detects file paths with line numbers', function() {
    let result = linkPaths('foo() b/c.js:44:55');
    expect(result).toContain('foo() <a');
    expect(result).toContain('class="-linked-path"');
    expect(result).toContain('data-path="b/c.js"');
    expect(result).toContain('data-line="44"');
    expect(result).toContain('data-column="55"');
    return expect(result).toContain('b/c.js:44:55');
  });

  it('detects file paths with Windows style drive prefix', function() {
    let result = linkPaths('foo() C:/b/c.js:44:55');
    return expect(result).toContain('data-path="C:/b/c.js"');
  });

  it('allow ommitting the column number', function() {
    let result = linkPaths('foo() b/c.js:44');
    expect(result).toContain('data-line="44"');
    return expect(result).toContain('data-column=""');
  });

  return it('links multiple paths', function() {
    let multilineResult = linkPaths(`\
foo() b/c.js:44:55
bar() b/c.js:45:56\
`
    );
    expect(multilineResult).toContain('foo() <a');
    return expect(multilineResult).toContain('bar() <a');
  });
});
