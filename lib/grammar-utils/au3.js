'use babel';

export default {
  getCommand() {
    try{
      var stdout = require('child_process').execSync('cmd /C REG QUERY "HKLM\\SOFTWARE\\AutoIt v3\\AutoIt" /v "InstallDir" /reg:32', {
        cwd: undefined,
        env: process.env,
        windowsHide: true,
      });
    }catch(e){}finally{
      var path = /[^\s]+\s+REG_[A-Z]+\s+(.*)$/m.exec(stdout);
      return ((path&&path[1])?path[1]:"");
    }
  }
}