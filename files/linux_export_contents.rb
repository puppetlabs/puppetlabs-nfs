#/usr/bin/env ruby

require 'yaml'

exports = Hash.new

class Export
	attr_accessor :name, :hosts

	def initialize(params)
		@name  = params[:name]
		@hosts = Array.new

		params[:host].to_a.each do |host|
			@hosts << Host.new :name => host, 
				:host_parameters => params[:parameters], 
				:subnet          => params[:subnet]
		end
	end

	def to_s
		"#{@name}\t" + hosts.map {|host| host.to_s }.join(' ')
	end
end

class Host
	attr_accessor :host_parameters, :name, :subnet

	def initialize(params)
		@name       = params[:name]
		@parameters = params[:host_parameters]
		@subnet     = params[:subnet]
	end

	def to_s
		@subnet = "/#{@subnet}" unless @subnet == :undef

		"#{@name}#{@subnet}(#{@parameters.join(',')})"
end

#Process the yaml files and
def init
	Dir["#{ARGV[1]}/**/*.yaml"].each do |yaml|
		resource = YAML.load( IO.read( yaml ) )

		# The export might be a string, so ensure array
		resource['export'].to_a.each do |exp|
			exports[exp] = Export :name => exp,
				:parameters => resource['parameters'],
				:host       => resource['host']
		end
	end
end

def contents
	exports.values.map { |export|
		export.to_s
	}.join("\n")
end

#Call init
init

case ARGV[0]
when "apply"
	file.open('/etc/exports', 'w') { |f|
		f.write contents
	}
when "check"
	IO.read( '/etc/exports' ) == contents
end
