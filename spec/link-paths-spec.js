'use babel';

import linkPaths from '../lib/link-paths';

describe('linkPaths', () => {
  it('detects file paths with line numbers', () => {
    const result = linkPaths('foo() b/c.js:44:55');
    expect(result).toContain('foo() <a');
    expect(result).toContain('class="-linked-path"');
    expect(result).toContain('data-path="b/c.js"');
    expect(result).toContain('data-line="44"');
    expect(result).toContain('data-column="55"');
    expect(result).toContain('b/c.js:44:55');
  });

  it('detects file paths with Windows style drive prefix', () => {
    const result = linkPaths('foo() C:\\b\\c.js:44:55');
    expect(result).toContain('data-path="C:\\b\\c.js"');
  });

  it('allow ommitting the column number', () => {
    const result = linkPaths('foo() b/c.js:44');
    expect(result).toContain('data-line="44"');
    expect(result).toContain('data-column=""');
  });

  it('allow ommitting the column and line numbers', () => {
    const result = linkPaths('foo() b/c.js');
    expect(result).toContain('data-path="b/c.js"');
    expect(result).toContain('data-line=""');
    expect(result).toContain('data-column=""');
  });

  it('links multiple paths', () => {
    const multilineResult = linkPaths('foo() b/c.js:44:5\nbar() b/c.js:45:56',
    );
    expect(multilineResult).toContain('foo() <a');
    expect(multilineResult).toContain('bar() <a');
  });

  it('detects python file paths with line numbers', () => {
    const result = linkPaths('File "b/c.py", line 4, in <module>');
    expect(result).toContain('data-path="b/c.py"');
    expect(result).toContain('data-line="4"');
    expect(result).toContain('data-column=""');
  });
});
