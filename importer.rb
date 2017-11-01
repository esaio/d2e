require 'pp'

class Importer
  def initialize(client, dir_path)
    @client = client
    @files = Dir.glob File.expand_path(File.join(dir_path, '*.md'))
  end
  attr_accessor :client, :files

  def wait_for(seconds)
    (seconds / 10).times do
      print '.'
      sleep 10
    end
    puts
  end

  def import(dry_run: true, start_index: 0)
     files.sort_by { |file| File.basename(file, '.*').to_i }.each.with_index do |file, index|
      next unless index >= start_index

      params = {
        name:     File.basename(file, '.*'),
        category: "Imports/DocBase",
        body_md:  File.read(file),
        wip:      false,
        message:  '[skip notice] Imported from DocBase',
        user:     'esa_bot',  # 記事作成者上書き: owner権限が必要
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
end
