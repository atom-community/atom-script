'use babel';

import os from 'os';

// Public: GrammarUtils.OperatingSystem - a module which exposes different
// platform related helper functions.
export default {
  isDarwin() {
    return this.platform() === 'darwin';
  },

  isWindows() {
    return this.platform() === 'win32';
  },

  isLinux() {
    return this.platform() === 'linux';
  },

  platform() {
    return os.platform();
  },

  release() {
    return os.release();
  },
};
