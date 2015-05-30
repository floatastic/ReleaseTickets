#!/usr/bin/env ruby

require_relative 'lib/config_parser'
require 'colorize'
require 'pp'

config = ConfigParser.full_config!

branches = `git ls-remote -t -h`

abort "Unable to retrieve branches and tags information from remote" if branches.to_s == ''

regexp_prefix = '([a-zA-Z0-9]{40})\t[a-zA-Z0-9\/]*?\/'
hash_from = branches[/#{regexp_prefix}#{Regexp.escape(config[:from_version])}/, 1]
hash_to = branches[/#{regexp_prefix}#{Regexp.escape(config[:to_version])}/, 1]

abort "Unable to get #{config[:from_version]} hash from remote." if hash_from.to_s == ''
abort "Unable to get #{config[:to_version]} hash from remote." if hash_to.to_s == ''

tickets_pattern = Regexp.escape(config['tickets_prefix']) + '[0-9]\+'
tickets_in_git = `git log #{hash_to}..#{hash_from} --graph --oneline --decorate --no-merges | grep -o '#{tickets_pattern}' | sort | uniq`
tickets_in_git = tickets_in_git.split("\n")

tickets_msg = "Found #{tickets_in_git.count} tickets in git"

if (tickets_in_git.count > 0) 
  tickets_string = tickets_in_git.join("\n")
  puts "#{tickets_msg}:\n#{tickets_string}".green
else
  puts "#{tickets_msg}".yellow
end
