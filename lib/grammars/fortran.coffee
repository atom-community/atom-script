exports['Fortran - Fixed Form'] =
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "gfortran '#{filepath}' -ffixed-form -o /tmp/f.out && /tmp/f.out"]

exports['Fortran - Free Form'] =
    'File Based':
      command: 'bash'
      args: ({filepath}) -> ['-c', "gfortran '#{filepath}' -ffree-form -o /tmp/f90.out && /tmp/f90.out"]

exports['Fortran - Modern'] = exports['Fortran - Free Form']
exports['Fortran - Punchcard'] = exports['Fortran - Fixed Form']
