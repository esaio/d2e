require_relative './base_converter'

class Converter < BaseConverter
  private

  def post_params(content)
    group_category = content['groups'].map{ |g| g['name'] }.join('-')
    category = "DocBase"
    category += "/#{group_category}" if group_category.length > 0

    body_md = <<~EOT
      url: #{content['url']}
      created_at: #{content['created_at']}
      user: #{content['user']['name']}


      #{reupload content['body']}
    EOT

    {
      name:     content['title'],
      category: category,
      tags:     content['tags'].map{ |tag| tag['name'] },
      body_md:  body_md,
      wip:      content['draft'],
      message:  '[skip notice] Imported from DocBase',
      user:     screen_name_for([content['user']['name']])
    }
  end

  def comments_params(comment_content)
    # NOTE: DocBaseのエクスポート機能にコメントの内容が暗号化されたまま出力される不具合があり、修正待ち

    body_md = <<~EOT
      created_at: #{comment_content['created_at']}
      user_id: #{comment_content['user_id']}


      #{reupload comment_content['encrypted_comment']}
    EOT

    {
      body_md: body_md,
      # user:    screen_name_for(comment_content['user']['name'])
    }
  end
end
