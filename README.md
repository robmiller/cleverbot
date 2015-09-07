# cleverbot (work in progress)

We have a knowledgebase that’s a Jekyll website. This bot gives us
a slash command in Slack that enables us to search that site.

It’s half done at the moment. The indexing and searching of a Jekyll
site is complete; the webhook for the Slash command is not.

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
