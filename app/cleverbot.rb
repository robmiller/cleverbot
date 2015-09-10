require "bundler/setup"

require "sinatra"
require "sinatra/param"

require_relative "../lib/cleverbot"

post "/search" do
  param :token,       String, is: ENV.fetch("SLACK_TOKEN")
  param :team_id,     String, required: true
  param :team_domain, String, required: true
  param :channel_id,  String, required: true
  param :user_id,     String, required: true
  param :user_name,   String, required: true
  param :command,     String, required: true
  param :text,        String, required: true

  source_directory = ENV.fetch("SOURCE_DIRECTORY")

  index_dir  = Pathname(__dir__) + ".." + "data"
  index_file = index_dir +
    (Digest::SHA256.hexdigest(source_directory) + ".json")

  begin
    index = Index.load(index_file)

    articles = index.find(params[:text])
  rescue Index::NotFound
    halt 500, "Index not built"
  end
end
