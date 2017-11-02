require 'pp'
require 'json'
require 'esa'
require_relative './converter'

class Importer
  def initialize(config)
    @config     = config
    @json_files = Dir.glob File.expand_path(File.join(config['json_dir'], '*.json'))
  end
  attr_reader :config, :json_files

  def import(dry_run: true, start_index: 0)
    converter = Converter.new(dry_run: dry_run, client: client, config: config, screen_names: screen_names)

    json_files.sort_by { |file| File.basename(file, '.*').to_i }.each.with_index do |file, index|
      next unless index >= start_index

      content = JSON.parse(File.read(file))
      params = converter.convert(content)

      if dry_run
        puts "***** index: #{index} *****"
        pp params
        puts
        next
      end

      print "[#{Time.now}] index[#{index}] #{params['name']} => "
      response = client.create_post(params[:post])
      case response.status
      when 201
        puts "created: #{response.body["full_name"]}"
      else
        puts "failure with status: #{response.status}"
        exit 1
      end

      post_number = response.body['number']
      params[:comments].each do |comment_param|
        client.create_comment(post_number, comment_param)
      end
    end
  end

  private

  def client
    @client ||= Esa::Client.new(
      access_token: config['esa_access_token'],
      current_team: config['esa_team_name'],
      api_endpoint: config['esa_api_endpoint']
    )
  end

  def screen_names
    @screen_names ||= client.members(per_page: 100).body['members'].map{ |m| m['screen_name'] }
  end
end
