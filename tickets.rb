#!/usr/bin/env ruby

require 'optparse'
require 'yaml'
require 'colorize'
require 'pp'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-f', '--from-version VERSION', 'Release version from which to start') { |v| options[:from_version] = v }
  opts.on('-t', '--to-version VERSION', 'Release version to end gathering tickets') { |v| options[:to_version] = v }
  opts.on_tail("-h", "--help", "Show this message") { puts opts; exit }
  opts.on_tail("--version", "Show version") { puts '0.0.1'; exit }

end.parse!

config = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/tickets_config.yaml')

abort "Missing argument: from version" if options[:from_version].to_s == ''
abort "Missing argument: to version"  if options[:to_version].to_s == ''
abort "Missing tickets pattern in config file"  if config['tickets_pattern'].to_s == ''

branches = `git ls-remote -t -h`

abort "Unable to retrieve branches and tags information from remote" if branches.to_s == ''

regexp_prefix = '([a-zA-Z0-9]{40})\t[a-zA-Z0-9\/]*?\/'
hash_from = branches[/#{regexp_prefix}#{Regexp.escape(options[:from_version])}/, 1]
hash_to = branches[/#{regexp_prefix}#{Regexp.escape(options[:to_version])}/, 1]

abort "Unable to get #{options.from_version} hash from remote." if hash_from.to_s == ''
abort "Unable to get #{options.to_version} hash from remote." if hash_to.to_s == ''

tickets_pattern = Regexp.escape(config['tickets_pattern'])
tickets_in_git = `git log #{hash_to}..#{hash_from} --graph --oneline --decorate --no-merges | grep -o '#{tickets_pattern}' | sort | uniq`
tickets_in_git = tickets_in_git.split("\n")

tickets_msg = "Found #{tickets_in_git.count} tickets in git"

if (tickets_in_git.count > 0) 
  puts "#{tickets_msg}: #{tickets_in_git.join('\n')}".green
else
  abort "#{tickets_msg}"
end
