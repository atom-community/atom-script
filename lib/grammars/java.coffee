path = require 'path'
{command} = GrammarUtils = require '../grammar-utils'

windows = GrammarUtils.OperatingSystem.isWindows()

args = (filepath, jar) ->
  jar = (jar ? path.basename(filepath)).replace /\.kt$/, '.jar'
  cmd = "kotlinc '#{filepath}' -include-runtime -d #{jar} && java -jar #{jar}"
  return GrammarUtils.formatArgs(cmd)

module.exports =

  Java:
    'File Based': {
      command
      args: (context) ->
        className = GrammarUtils.Java.getClassName context
        classPackages = GrammarUtils.Java.getClassPackage context
        sourcePath = GrammarUtils.Java.getProjectPath context
        if windows
          return ["/c javac -Xlint #{context.filename} && java #{className}"]
        else ['-c', "javac -sourcepath '#{sourcePath}' -d /tmp '#{context.filepath}' && java -cp /tmp #{classPackages}#{className}"]
    }
  Kotlin:
    'Selection Based': {
      command
      args: (context) ->
        code = context.getCode()
        tmpFile = GrammarUtils.createTempFileWithCode(code, '.kt')
        return args(tmpFile)
    }
    'File Based': {
      command
      args: ({filepath, filename}) -> args(filepath, "/tmp/#{filename}")
    }
  Processing:
    'File Based':
      command: 'processing-java'
      args: ({filepath}) -> ["--sketch='#{path.dirname(filepath)}'", '--run']
