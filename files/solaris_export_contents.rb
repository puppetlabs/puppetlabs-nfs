#!/usr/bin/env ruby

require 'yaml'

exports = Hash.new

class Export
  attr_accessor :name, :hosts

  def initialize(params)
    @name       = params[:name]
    @parameters = Hash.new

    params[:parameters].to_a.each do |parameter|
      #Catch any duplicate resources defined
      #if @hosts.has_key? host
        #raise "ERROR: Duplicate resource found. nfs::exporthost['#{params['resource_title']}'] and nfs::exporthost['#{@hosts[host].resource_title}'] define the same host for the export #{params[:name]}"
      #end

      @parameters[parameter] = Parameter.new(:name => parameter,
        :subnet          => params[:subnet],
        :resource_title  => params[:resource_title]
      )

      params[:host].to_a.each do |h|
        @parameters[parameter].addhost :host => h
      end
    end
  end

  def to_s
    'share -F nfs -o ' + @parameters.values.map {|parameter| parameter.to_s }.join(',') + "    #{@name}"
  end
end

class Parameter
  attr_accessor :hosts, :name, :subnet, :resource_title

  def initialize(params)
    @name           = params[:name]
    @subnet         = params[:subnet]
    @resource_title = params[:resource_title]
    @hosts          = Array.new
  end

  def addhost( params )
    if @hosts.include? params[:host]
        raise "ERROR: "
    end

    @hosts << params[:host]
  end

  def to_s
    host_string = String.new
    @subnet = @subnet == :undef ? '' : "/#{@subnet}"

    unless @hosts.empty?
      host_string = '=' + @hosts.join("#{@subnet}:")
    end

    "#{@name}#{host_string}"
  end
end

def contents(exports)
  exports.values.map { |export|
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
    exports[exp] = Export.new(:name => exp,
      :parameters => resource['parameters'],
      :subnet     => resource['subnet'],
      :host       => resource['host']
    )
  end
end

puts contents( exports )
case ARGV[0]
when "apply"
  File.open('/etc/dfs/dfstab', 'w') { |f|
    f.write contents( exports )
  }
when "check"
  exit IO.read( '/etc/exports' ) == contents( exports )
end
