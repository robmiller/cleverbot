require_relative "../../spec_helper"

require "json"

describe Index do
  let(:sample_dir) { Pathname(__dir__) + ".." + ".." + "data" }
  let(:scanner) { Scanner.new(sample_dir) }
  let(:corpus) { Corpus.new(scanner) }
  let(:index) { Index.build(corpus) }

  let(:posts) do
    {
      foo: sample_dir + "_posts" + "2015-01-01-foo.markdown",
      bar: sample_dir + "_posts" + "2014-01-01-bar.markdown",
    }
  end

  describe ".load" do
    it "loads an index from a file" do
      file = StringIO.new
      index.persist(file)
      file.rewind
      index = Index.load(file)
      expect(index.find("foo").length).to eq(1)
    end
  end

  describe ".build" do
    it "builds a new index" do
      expect(index).to be_an(Index)
    end

    it "contains the articles from the corpus" do
      expect(index.articles).to match_array(posts.values)
    end
  end

  describe "#find" do
    let(:index) { Index.load(sample_dir + "index.json") }

    it "finds posts by keyword" do
      expect(index.find("foo")).to eq([posts[:foo]])
    end

    it "is case insensitive" do
      expect(index.find("FOO")).to eq([posts[:foo]])
      expect(index.find("FoO")).to eq([posts[:foo]])
    end

    it "finds posts with multiple keywords" do
      expect(index.find("foo wotsit")).to eq([posts[:foo]])
    end

    it "only finds articles with all keywords" do
      expect(index.find("foo nonexistent")).to eq([])
    end

    it "finds posts by title" do
      expect(index.find("dumpling")).to eq([posts[:foo]])
    end
  end

  describe "#persist" do
    it "writes the index to a file" do
      file = StringIO.new
      index.persist(file)
      file.rewind
      expect{JSON.parse(file.read)}.to_not raise_error
    end
  end
end
