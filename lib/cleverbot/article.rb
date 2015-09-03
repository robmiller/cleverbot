class Article
  attr_reader :title, :content, :category, :filename, :keywords

  def initialize(title:, content:, category: nil, filename: nil, keywords: nil)
    @title    = title
    @category = category
    @content  = content
    @filename = Pathname(filename.to_s)
    @keywords = keywords
  end
end
