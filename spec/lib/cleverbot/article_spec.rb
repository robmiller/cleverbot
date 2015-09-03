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
end
