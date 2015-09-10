require "bundler/setup"

require "sinatra"
require "sinatra/param"

require "slack-notifier"

require_relative "../lib/cleverbot"

set :views, settings.root + "/views"
set :erb, trim: "-"

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

    @query    = params[:text]
    @articles = index.find(@query)
    @articles = @articles.map { |a| Article.from_file(a) }

    @base_url = ENV.fetch("SITE_URL")

    notifier = Slack::Notifier.new(
      ENV.fetch("SLACK_WEBHOOK_URL"),
      channel: params[:channel_id],
    )

    message = erb :message
    notifier.ping(message)
  rescue Index::NotFound
    halt 500, "Index not built"
  end
end
