require "yaml"
require "phrasie"

class Corpus
  def initialize(scanner)
    @scanner = scanner
  end

  def articles
    build unless built?

    @articles
  end

  private

  attr_reader :scanner

  def built?
    !!@built
  end

  def build
    @articles = scanner.posts.map do |file|
      File.open(file) do |f|
        extract_data(f)
      end
    end

    @built = true

    @articles
  end

  def extract_data(file)
    content = file.read
    header  = YAML.load(extract_header(content))
    text    = extract_text(content)

    extractor = Phrasie::Extractor.new
    keywords  = extract_keywords(extractor, text)

    Article.new(title: header["title"],
                category: header["category"],
                content: text,
                keywords: keywords,
                filename: file.path)
  end

  def extract_header(content)
    header = content.match(/^---$(.*?)^---$/m)
    header[1]
  end

  def extract_text(content)
    content.sub(extract_header(content), "")
  end

  def extract_keywords(extractor, text)
    extractor.phrases(text)
  end
end
