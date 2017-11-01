require 'esa'
require 'optparse'
require 'yaml'
require_relative './importer'

config = YAML.load_file('config.yml')
users  = YAML.load_file('users.yml')
importer = Importer.new(config: config, users: users)

params = ARGV.getopts('', 'run', 'start:0')
importer.import(dry_run: !params['run'], start_index: params['start'].to_i)
