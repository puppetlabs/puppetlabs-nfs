#!/usr/bin/env ruby

require 'yaml'

exports = Array.new

class Export
  attr_accessor :name, :hosts

  def initialize(params)
    @name       = params[:name]
    @hosts      = params[:host]
    @mask       = params[:subnet]
    @network    = params[:network]
    @offline    = params[:offline]
    @sec        = params[:sec]
    @ro         = params[:ro]
    @alldirs    = params[:alldirs]
    @maproot    = params[:maproot]
    @mapall     = params[:mapall]
    @parameters = Array.new

    self.instance_variables.reject{ |v| ['@name','@hosts','@parameters'].include? v }.each do |var|
        var_val = self.instance_variable_get(var)
        unless var_val == 'UNSET'

          #This looks funny but the variable could be TrueClass or a String/Array
          if var_val.class  == TrueClass
            @parameters << "  -#{var[1..-1]}"
          else
            @parameters << "  -#{var[1..-1]}=#{var_val.to_a.join(':')}"
          end
        end
    end
  end

  def to_s
    @hosts = @hosts == 'UNSET' ? [] : @hosts

    "#{@name}\t #{@parameters.join(' ')} #{@hosts.to_a.join(' ')}"
  end
end

class Host
  attr_accessor :host_parameters, :name, :subnet, :resource_title

  def initialize(params)
    @name           = params[:name]
    @parameters     = params[:host_parameters]
    @subnet         = params[:subnet]
    @resource_title = parmas[:resource_title]
  end

  def to_s
    @subnet = @subnet == 'UNSET' ? '' : "/#{@subnet}"

    "#{@name}#{@subnet}(#{@parameters.join(',')})"
  end
end

def contents(exports)
  IO.read( "#{ARGV[1]}/HEADER" ) + "\n" + exports.map { |export|
    export.to_s
  }.join("\n")
end

#Do some validation
unless (ARGV.size == 2) and (['apply','check'].include? ARGV[0])
  fail "ERROR: Requires two parameters. [apply|check] work_directory"
end

#Process the yaml files 
Dir["#{ARGV[1]}/**/*.yaml"].each do |yaml|
  resource = YAML.load( IO.read( yaml ) )

  # The export might be a string, so ensure array
  resource['export'].to_a.each do |exp|
    exports << Export.new(:name => exp,
      :parameters   => resource['parameters'],
      :subnet       => resource['subnet'],
      :host         => resource['host'],
      :network      => resource['network'],
      :offline      => resource['offline'],
      :sec          => resource['sec'],
      :ro           => resource['ro'],
      :alldirs      => resource['alldirs'],
      :maproot      => resource['maproot'],
      :mapall       => resource['mapall']
    )
  end
end

case ARGV[0]
when "apply"
  File.open('/etc/exports', 'w') { |f|
    f.write contents( exports )
  }
when "check"
  exit IO.read( '/etc/exports' ) == contents( exports )
end
