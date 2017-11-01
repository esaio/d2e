require 'esa'
require 'optparse'
require 'yaml'
require_relative './importer'

params = ARGV.getopts('', 'run', 'start:0')
config = YAML.load_file('config.yml')
config = YAML.load_file('dirs.yml')
config = YAML.load_file('users.yml')

importer = Importer.new(client, config: config, users: users)
importer.import(dry_run: !params['run'], start_index: params['start'].to_i)
