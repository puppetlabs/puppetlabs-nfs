module Puppet::Parser::Functions
  newfunction(:variable_select) do |args|
    variable = args[0]
    default  = args[1]

    variable == :undef ? default : variable
  end
end
