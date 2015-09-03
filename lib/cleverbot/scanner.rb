class Scanner
  attr_reader :directory

  def initialize(directory)
    @directory = Pathname(directory)
  end

  def posts
    Dir[@directory + "_posts" + "*"].map { |f| Pathname(f) }
  end
end
