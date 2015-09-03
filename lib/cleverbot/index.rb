require "phrasie"
require "json"

class Index
  def initialize(index = {})
    @index = index
  end

  def find(query)
    results = []

    query.downcase.split.each do |keyword|
      if results.empty?
        results = @index[keyword]
      else
        results &= Array(@index[keyword])
      end
    end

    Array(results).flatten
  end

  def persist(file)
    file.write(JSON.generate(@index))
  end

  def articles
    @index.values.flatten.uniq
  end

  def self.load(file)
    if file.respond_to?(:read)
      contents = file.read
    else
      contents = File.read(file)
    end

    index = JSON.parse(contents)
    index.each do |_, files|
      files.map! { |f| Pathname(f).realpath }
    end

    new(index)
  end

  def self.build(corpus)
    index = new

    corpus.articles.each do |article|
      keywords = index.send(:keywords_with_title_words, article)

      keywords.each do |keyword|
        index.send(:add_entry, keyword.first, article)
      end
    end

    index
  end

  private

  def keywords_with_title_words(article)
    extractor   = Phrasie::Extractor.new
    title_words = extractor.phrases(article.title,
                                    strength: 1,
                                    occur: 1)

    title_words + article.keywords
  end

  def add_entry(keyword, article)
    keyword = keyword.downcase

    @index[keyword] ||= []
    return if @index[keyword].include?(article.filename)

    @index[keyword] << article.filename
  end
end
