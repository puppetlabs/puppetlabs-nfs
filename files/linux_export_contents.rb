#!/usr/bin/env ruby

require 'yaml'

exports = Hash.new

class Export
  attr_accessor :name, :hosts

  def initialize(params)
    @name  = params[:name]
    @hosts = Hash.new

    params[:host].to_a.each do |host|
      #Catch any duplicate resources defined
      if @hosts.has_key? host
        raise "ERROR: Duplicate resource found. nfs::exporthost['#{params['resource_title']}'] and nfs::exporthost['#{@hosts[host].resource_title}'] define the same host for the export #{params[:name]}"
      end

      @hosts[host] = Host.new(:name => host, 
        :host_parameters => params[:parameters], 
        :subnet          => params[:subnet],
        :resource_title  => params[:resource_title]
      )
    end 
  end 

  def to_s
    "#{@name}\t" + @hosts.values.map {|host| host.to_s }.join(' ')
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
  IO.read( "#{ARGV[1]}/HEADER" ) + "\n" + exports.values.map { |export|
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
    exports[exp] = Export.new :name => exp,
      :parameters => resource['parameters'],
      :subnet     => resource['subnet'],
      :host       => resource['host']
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
