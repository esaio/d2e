class BaseConverter
  def initialize(screen_names)
    @screen_names = screen_names
  end
  attr_reader :screen_names

  def convert(content)
    {
      post:     post_params(content),
      comments: comments_params(content)
    }
  end

  private

  def post_params(content)
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def comments_params(content)
    raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
  end

  def screen_name_for(name)
    return name if screen_names.include?(name)
    'esa_bot'
  end
end
