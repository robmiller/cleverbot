require_relative "../../spec_helper"

describe Article do
  it "has a title and content" do
    article = Article.new(title: "An Article", content: "This is an article")

    expect(article.title).to eq("An Article")
    expect(article.content).to eq("This is an article")
  end

  it "has a category" do
    article = Article.new(
      title: "An Article",
      content: "This is an article",
      category: "foo",
    )

    expect(article.category).to eq("foo")
  end

  it "has a filename" do
    article = Article.new(
      title: "An Article",
      content: "This is an article",
      filename: Pathname(__dir__) + "foo.txt"
    )

    expect(article.filename).to eq(Pathname(__dir__) + "foo.txt")
  end

  it "has keywords" do
    article = Article.new(
      title: "An Article",
      content: "This is an article",
      keywords: [["foo", 1, 1], ["bar", 1, 1]]
    )

    expect(article.keywords).to eq([["foo", 1, 1], ["bar", 1, 1]])
  end

  let(:sample_file) do
    Pathname(__dir__) + ".." + ".." + "data" + "_posts" + "2015-01-01-foo.markdown"
  end

  describe ".from_file" do
    it "will read information from a file" do
      article = Article.from_file(sample_file)
      expect(article.title).to eq("Foo Dumpling")
      expect(article.category).to eq("foo")
      expect(article.content).to match(/This is a post about foo/)
    end
  end

  describe "#url" do
    it "generates a URL for an article" do
      article = Article.new(
        title: "An Article",
        content: "This is an article",
        category: "foo",
        filename: "/var/foo/2015-01-01-an-article.markdown",
      )

      expect(article.url("http://example.com")).to eq("http://example.com/foo/an-article.html")
    end
  end
end
