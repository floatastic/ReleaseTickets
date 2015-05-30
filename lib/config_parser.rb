require 'optparse'
require 'yaml'

class ConfigParser
  def self.full_config!
    options = {}
	OptionParser.new do |opts|
	  opts.banner = "Usage: example.rb [options]"

	  opts.on('-f', '--from-version VERSION', 'Release version from which to start') { |v| options[:from_version] = v }
	  opts.on('-t', '--to-version VERSION', 'Release version to end gathering tickets') { |v| options[:to_version] = v }
	  opts.on_tail("-h", "--help", "Show this message") { puts opts; exit }
	  opts.on_tail("--version", "Show version") { puts '0.2.0'; exit }

	end.parse!

	config = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/../config.yaml')

	abort "Missing argument: from version" if options[:from_version].to_s == ''
	abort "Missing argument: to version"  if options[:to_version].to_s == ''
	abort "Missing tickets prefix in config file"  if config['tickets_prefix'].to_s == ''

	return options.merge(config)
  end
end