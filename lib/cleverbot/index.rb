require "phrasie"
require "json"

class Index
  class NotFound < Exception; end

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
    begin
      if file.respond_to?(:read)
        contents = file.read
      else
        contents = File.read(file)
      end
    rescue Errno::ENOENT
      raise NotFound, %(Index file #{file} not found)
    end

    new(load_json(contents))
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

  def self.load_json(contents)
    index = JSON.parse(contents)
    index.each do |_, files|
      files.map! { |f| Pathname(f).realpath }
    end

    index
  end
end
