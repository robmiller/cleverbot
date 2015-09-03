require_relative "../../spec_helper"

describe Scanner do
  let(:sample_dir) { Pathname(__dir__) + ".." + ".." + "data" }
  let(:scanner) { Scanner.new(sample_dir) }

  describe ".initialize" do
    it "takes a directory of files" do
      expect(scanner.directory).to eq(sample_dir)
    end

    it "converts the path to a Pathname" do
      expect(Scanner.new(sample_dir.to_s).directory).to eq(sample_dir)
    end
  end

  describe "#posts" do
    it "finds posts in the given directory" do
      posts = [
        sample_dir + "_posts" + "2014-01-01-bar.markdown",
        sample_dir + "_posts" + "2015-01-01-foo.markdown",
      ]
      expect(scanner.posts).to eq(posts)
    end
  end
end
