# cleverbot (work in progress)

We have a knowledgebase that’s a Jekyll website. This bot gives us
a slash command in Slack that enables us to search that site.

## Installation

(For now)

1. Clone the repository
2. `bundle install`

## Indexing your site

Run the following command either in a Git hook or a cron job. It will
build a persistent index of the content on your site:

	$ bin/index path/to/jekyll/site

The index command assumes that posts are stored in a directory called
`_posts`, one level below the path that you pass to the command.

## Setting up Slack

You need to create two integrations in Slack:

1. A slash command that points to the URL of your server
2. An incoming webhook that the search server will use to post search
   results into Slack

## Running the server

The search server is a Sinatra application. It relies on a few
environment variables:

* `SOURCE_DIRECTORY` — the fully qualified path to your Jekyll site.
* `SLACK_TOKEN` — the token for your slash command in Slack
* `SLACK_WEBHOOK_URL` — the URL of your incoming webhook integration in
  Slack
* `SITE_URL` — the URL of the homepage of your site, used as the base
  for article URLs in search results

With these environment variables set, use `rackup` to start the server:

	$ SOURCE_DIRECTORY=”/var/www/kb” SLACK_TOKEN=”abc123abc123” SLACK_WEBHOOK_URL=”https://hooks.slack.com/services/foo/bar/baz” SITE_URL=”http://example.com” rackup

It’s assumed that your service will be very low traffic, and therefore
that running the server through WEBrick is fine.
