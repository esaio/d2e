require 'esa'
require 'optparse'
require_relative './importer'

params = ARGV.getopts('', 'run', 'start:0')

require "pry"; binding.pry

client = Esa::Client.new(
  access_token: 'xxxxx',
  current_team: 'your-team-name', # 移行先のチーム名(サブドメイン)
)
importer = Importer.new(client, '/path/to/export_dir') # docbaseからexportしたzipを展開してできたフォルダのpath

importer.import(dry_run: !params['run'], start_index: params['start'].to_i)
