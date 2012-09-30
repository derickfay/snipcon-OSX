#!/usr/bin/env ruby 

# snipcon.rb
# Lee Turner (http://www.leeturner.co)
# Use and modify freely, attribution appreciated
# 
# This script works with the Day One[1] command line utility
# It parses an input string for an exclamation point prefix to mark starred
# and/or a [date string] at the beginning to parse natural language dates
# 
# Requirements:
# plist ruby gem
#
# Example usage:
#

require 'plist'

REPLACE_THIS = ";;"
WITH_THIS = ";;;"

# Check the command line args
if ARGV.length != 1
	puts "\nYou must specify a Textexpander snippet file - snipcon.rb file.textexpander\n\n"
	Process.exit(-1)
else
	input = ARGV[0]
	# If the param has been specified make sure the file exists.
	if File.exists?(input) == false then
		puts "\nThe file you have specified does not exist\n\n"
		Process.exit(-1)
	end
end

result = Plist::parse_xml(input)
begin
	# Make sure we have a valid plist file.
	snippets = result['snippetsTE2']
rescue
	puts "\nThe file you have specified does not appear to be a valid Textexpander snippet file (in plist format)\n\n"
	Process.exit(-1)
end

# Loop through the snippets in the file.
snippets.each do |snippet|
	abbrev = snippet['abbreviation']
	# Perform any substitutions
	abbrev = abbrev.gsub(REPLACE_THIS, WITH_THIS)
	# Output the snippet abbreviation
	puts "\nsnippet #{abbrev}\n"

	# Grab the actual text of the snippet
	plainText = snippet['plainText']
	# Split the lines
	lines =	plainText.split("\n")
	# Each line output it with a tab at the front.
	lines.each do |line|
		puts "\t #{line.chomp}"
	end
end
