'use babel';

import Runner from '../lib/runner';
import ScriptOptions from '../lib/script-options';

describe('Runner', () => {
  beforeEach(function () {
    this.command = 'node';
    this.runOptions = new ScriptOptions();
    this.runOptions.cmd = this.command;
    return this.runner = new Runner(this.runOptions);
  });

  afterEach(function () {
    return this.runner.destroy();
  });

  return describe('run', () => {
    it('with no input', function () {
      runs(() => {
        this.output = null;
        this.runner.onDidWriteToStdout(output => this.output = output,
        );
        return this.runner.run(this.command, ['./spec/fixtures/outputTest.js'], {});
      },
      );

      waitsFor(() => this.output !== null
      , 'File should execute', 500);

      return runs(() => expect(this.output).toEqual({ message: 'hello\n' }),
      );
    });

    it('with an input string', function () {
      runs(() => {
        this.output = null;
        this.runner.onDidWriteToStdout(output => this.output = output,
        );
        return this.runner.run(this.command, ['./spec/fixtures/ioTest.js'], {}, 'hello');
      },
      );

      waitsFor(() => this.output !== null
      , 'File should execute', 500);

      return runs(() => expect(this.output).toEqual({ message: 'TEST: hello\n' }),
      );
    });

    it('exits', function () {
      runs(() => {
        this.exited = false;
        this.runner.onDidExit(() => this.exited = true,
        );
        return this.runner.run(this.command, ['./spec/fixtures/outputTest.js'], {});
      },
      );

      return waitsFor(() => this.exited
      , 'Should receive exit callback', 500);
    });

    it('notifies about writing to stderr', function () {
      runs(() => {
        this.failedEvent = null;
        this.runner.onDidWriteToStderr(event => this.failedEvent = event,
        );
        return this.runner.run(this.command, ['./spec/fixtures/throw.js'], {});
      },
      );

      waitsFor(() => this.failedEvent
      , 'Should receive failure callback', 500);

      return runs(() => expect(this.failedEvent.message).toMatch(/kaboom/),
      );
    });

    return it('terminates stdin', function () {
      runs(() => {
        this.output = null;
        this.runner.onDidWriteToStdout(output => this.output = output,
        );
        return this.runner.run(this.command, ['./spec/fixtures/stdinEndTest.js'], {}, 'unused input');
      },
      );

      waitsFor(() => this.output !== null
      , 'File should execute', 500);

      return runs(() => expect(this.output).toEqual({ message: 'stdin terminated\n' }),
      );
    });
  });
});
