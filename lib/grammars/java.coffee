GrammarUtils = require '../grammar-utils'

windows = GrammarUtils.OperatingSystem.isWindows()

module.exports =

  Java:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: (context) ->
        className = GrammarUtils.Java.getClassName context
        classPackages = GrammarUtils.Java.getClassPackage context
        sourcePath = GrammarUtils.Java.getProjectPath context
        if windows
          return ["/c javac -Xlint '#{context.filename}' && java #{className}"]
        else ['-c', "javac -sourcepath #{sourcePath} -d /tmp '#{context.filepath}' && java -cp /tmp #{classPackages}#{className}"]

  Kotlin:
    'Selection Based':
      command: 'bash'
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.kt')
        jarName = tmpFile.replace /\.kt$/, '.jar'
        return ['-c', "kotlinc #{tmpFile} -include-runtime -d #{jarName} && java -jar #{jarName}"]

    'File Based':
      command: 'bash'
      args: ({filepath, filename}) ->
        jarName = filename.replace /\.kt$/, '.jar'
        return ['-c', "kotlinc '#{filepath}' -include-runtime -d /tmp/#{jarName} && java -jar /tmp/#{jarName}"]

  Processing:
    'File Based':
      command: if windows then 'cmd' else 'bash'
      args: ({filepath, filename}) ->
        if windows
          return ['/c processing-java --sketch=' + filepath.replace("\\#{filename}", '') + ' --run']
        else ['-c', 'processing-java --sketch=' + filepath.replace("/#{filename}", '') + ' --run']
