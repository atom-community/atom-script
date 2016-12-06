'use babel';

import Runner from '../lib/runner';
import ScriptOptions from '../lib/script-options';

describe('Runner', () => {
  beforeEach(() => {
    this.command = 'node';
    this.runOptions = new ScriptOptions();
    this.runOptions.cmd = this.command;
    this.runner = new Runner(this.runOptions);
  });

  afterEach(() => {
    this.runner.destroy();
  });

  describe('run', () => {
    it('with no input', () => {
      runs(() => {
        this.output = null;
        this.runner.onDidWriteToStdout((output) => {
          this.output = output;
        });
        this.runner.run(this.command, ['./spec/fixtures/outputTest.js'], {});
      });

      waitsFor(() => this.output !== null, 'File should execute', 500);

      runs(() => expect(this.output).toEqual({ message: 'hello\n' }));
    });

    it('with an input string', () => {
      runs(() => {
        this.output = null;
        this.runner.onDidWriteToStdout((output) => {
          this.output = output;
        });
        this.runner.run(this.command, ['./spec/fixtures/ioTest.js'], {}, 'hello');
      });

      waitsFor(() => this.output !== null, 'File should execute', 500);

      runs(() => expect(this.output).toEqual({ message: 'TEST: hello\n' }));
    });

    it('exits', () => {
      runs(() => {
        this.exited = false;
        this.runner.onDidExit(() => {
          this.exited = true;
        });
        this.runner.run(this.command, ['./spec/fixtures/outputTest.js'], {});
      });

      waitsFor(() => this.exited, 'Should receive exit callback', 500);
    });

    it('notifies about writing to stderr', () => {
      runs(() => {
        this.failedEvent = null;
        this.runner.onDidWriteToStderr((event) => {
          this.failedEvent = event;
        });
        this.runner.run(this.command, ['./spec/fixtures/throw.js'], {});
      });

      waitsFor(() => this.failedEvent, 'Should receive failure callback', 500);

      runs(() => expect(this.failedEvent.message).toMatch(/kaboom/));
    });

    it('terminates stdin', () => {
      runs(() => {
        this.output = null;
        this.runner.onDidWriteToStdout((output) => {
          this.output = output;
        });
        this.runner.run(this.command, ['./spec/fixtures/stdinEndTest.js'], {}, 'unused input');
      });

      waitsFor(() => this.output !== null, 'File should execute', 500);

      runs(() => expect(this.output).toEqual({ message: 'stdin terminated\n' }));
    });
  });
});
