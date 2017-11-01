require 'pp'
require 'json'

class Importer
  def initialize(config:, users:)
    @config = config
    @users  = users

    @json_files = Dir.glob File.expand_path(File.join(config['json_dir'], '*.json'))
  end
  attr_reader :config, :json_files

  def import(dry_run: true, start_index: 0)
    # TODO: memberのマッピングをチェック。docbaseとesaの両方のAPIを叩く必要がありそう

    json_files.sort_by { |file| File.basename(file, '.*').to_i }.each.with_index do |file, index|
      next unless index >= start_index

      content = JSON.parse(File.read(file))

      params = {
        name:     content['title'],
        category: "Imports/DocBase", # TODO: gruopを考慮
        tags:      content['tags'].map{ |tag| tag.values.first },
        body_md:   content['body'], # TODO: 画像とファイルの再アップロード, url、作成者を含める
        wip:      content['draft'],
        message:  '[skip notice] Imported from DocBase',
        user: @users[content['user']['name']] || 'esa_bot'
      }

      if dry_run
        puts "***** index: #{index} *****"
        pp params
        puts
        next
      end

      print "[#{Time.now}] index[#{index}] #{params['name']} => "
      response = client.create_post(params)
      case response.status
      when 201
        puts "created: #{response.body["full_name"]}"
      when 429
        retry_after = (response.headers['Retry-After'] || 20 * 60).to_i
        puts "rate limit exceeded: will retry after #{retry_after} seconds."
        wait_for(retry_after)
        redo
      else
        puts "failure with status: #{response.status}"
        exit 1
      end
    end
  end

  private

  def client
    @client ||= Esa::Client.new(
      access_token: config['access_token'],
      current_team: config['team_name'],
      api_endpoint: config['api_endpoint']
    )
  end

  def wait_for(seconds)
    (seconds / 10).times do
      print '.'
      sleep 10
    end
    puts
  end
end
