require_relative "../spec_helper"

require_relative "../../app/cleverbot"

describe "searching" do
  before do
    ENV["SOURCE_DIRECTORY"] =
      (Pathname(__dir__) + ".." + ".." + "data").to_s
    ENV["SLACK_TOKEN"] = "VALID_TOKEN"
    ENV["SLACK_WEBHOOK_URL"] = "https://example.slack.com/foo"
    ENV["SITE_URL"] = "http://example.com"
  end

  let(:valid_params) do
    {
      token: "VALID_TOKEN",
      team_id: "T0001",
      team_domain: "example",
      channel_id: "C2147483705",
      channel_name: "test",
      user_id: "U2147483697",
      user_name: "Steve",
      command: "/kb",
      text: "foo",
    }
  end

  let(:sample_dir) { Pathname(__dir__) + ".." + ".." + "data" }
  let(:index_file) { sample_dir + (Digest::SHA256.hexdigest(sample_dir.to_s) + ".json") }

  let(:index) do
    scanner = Scanner.new(sample_dir)
    corpus  = Corpus.new(scanner)
    Index.build(corpus)
  end

  it "requires webhook params" do
    post "/search"
    expect(last_response).to be_bad_request
  end

  it "returns an error if the token is incorrect" do
    ENV["SLACK_TOKEN"] = "ANOTHER_TOKEN"

    post "/search", valid_params
    expect(last_response).to be_bad_request
  end

  it "doesn't return an error if the token is correct" do
    post "/search", valid_params
    expect(last_response).to_not be_bad_request
  end

  it "returns an error if the index doesn't exist" do
    File.unlink(index_file) if File.exist?(index_file)

    post "/search", valid_params
    expect(last_response).to be_server_error
  end

  it "returns ok if the index does exist" do
    index.persist(index_file)

    post "/search", valid_params
    expect(last_response).to be_ok
  end
end
