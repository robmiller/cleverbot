class Article
  attr_reader :title, :content, :category, :filename, :keywords

  def initialize(title:, content:, category: nil, filename: nil, keywords: nil)
    @title    = title
    @category = category
    @content  = content
    @filename = Pathname(filename.to_s)
    @keywords = keywords
  end

  def url(base_url)
    base_url += "/" unless base_url.end_with? "/"

    "#{base_url}#{category}/#{slug}"
  end

  def slug
    filename.basename.sub(/^[0-9\-]+/, "").sub(/\.markdown$/, "")
  end

  def self.from_file(filename)
    File.open(filename) do |file|
      content = file.read

      header  = content.match(/^---$.*^---$/m)[0]
      content = content.sub(header, "")

      header = YAML.load(header)

      new(title: header["title"],
          content: content,
          category: header["category"],
          filename: filename)
    end
  end
end
