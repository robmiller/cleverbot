require_relative "../../spec_helper"

describe Corpus do
  let(:sample_dir) { Pathname(__dir__) + ".." + ".." + "data" }
  let(:scanner) { Scanner.new(sample_dir) }
  let(:corpus) { Corpus.new(scanner) }

  describe "#build" do
    it "creates articles for each file" do
      articles = corpus.articles
      expect(articles.length).to eq(2)
      expect(articles.first.title).to eq("Bar")
      expect(articles.first.category).to eq("baz")
      expect(articles.first.content).to match(/This is an article about bar\./)
      expect(articles.first.keywords).to eq([["bar", 3, 1]])
    end
  end
end
