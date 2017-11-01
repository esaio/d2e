require 'optparse'
require 'yaml'
require_relative 'lib/importer'

config = YAML.load_file('config.yml')
importer = Importer.new(config)

params = ARGV.getopts('', 'run', 'start:0')
importer.import(dry_run: !params['run'], start_index: params['start'].to_i)
