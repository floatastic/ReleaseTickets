#!/usr/bin/env ruby

require_relative 'lib/config_parser'
require_relative 'lib/git_log_parser'
require 'colorize'
require 'pp'

config = ConfigParser.full_config!

git_log_parser = GitLogParser.new(config[:from_version], config[:to_version], config['tickets_prefix'])
tickets_in_git = git_log_parser.tickets!

def print_summary(tickets)
  tickets_msg = "Found #{tickets.count} tickets"

  if (tickets.count > 0) 
    puts "#{tickets_msg}:".green
    tickets.each { |ticket| puts ticket.verified ? "#{ticket}".green : "#{ticket}".yellow }
  else
    puts "#{tickets_msg}".yellow
  end
end

print_summary(tickets_in_git)
