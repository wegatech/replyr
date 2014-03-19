#Replyr [![Build Status](https://travis-ci.org/wursttheke/replyr.png?branch=master)](https://travis-ci.org/wursttheke/replyr)

Replyr lets you receive and process reply emails with Rails. And with ease!

#### Example

A User gets an email notification about a comment being posted on his page. No he answers this email directly from his email client with a followup comment. Replyr receives the anwser and creates a new comment on his page.

#### How does this work?

Replyr generates a special `reply_to` email address which is unique to the user receiving the notification and the object in question (e.g. a comment). The resulting reply email address looks something like this:

reply-comment-12-56-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@example.com

This address will be set as the reply_to address in your outgoing email. When the user answers the email, the message will be sent to this unique address and Replyr will be able to handle it accordingly. Replyr will check for the validity of the reply email and then pass it to your custom code, which will then create a new comment.

#### How do the emails get into my app?

Replyr uses the awesome [Mailman Gem](https://github.com/titanous/mailman) to receive the reply emails. It can be configured to get the emails via Maildir, from a POP3- or from an IMAP-Server. It runs as a background daemon and observes your email directory or polls your email server for new emails. See the documentation of Mailman on how to set it up.

https://github.com/titanous/mailman

## Requirements

  - Ruby >= 1.9.2
  - Rails 3 >= 3.1 or Rails 4

## Installtion

#### Add the gem to your `Gemfile`

```ruby
gem 'replyr'
```

#### Install

```bash
$ bundle
$ rails g replyr:install
```

#### Edit initializer 

Open up `config/initializers/replyr.rb` and set the host name of your reply email address.

```ruby
Ryplr.config.host = "yourdomain.com"
```

#### Setup Mailman Gem

The Install Generator will already have created a `script/mailman_server` file which boots up the Mailman background job. According to your setup you will have to configure the file to your needs. By default it is setup to observe the `~/Maildir` folder in your home directory.

## Usage

#### Make a model accept replies

Update your ActiveRecord models you want to reply to by adding a `handle_reply` like this:

```ruby
class Comment < ActiveRecord::Base
  belongs_to :user
  
  handle_reply do |comment, user, text, files|
    Comment.create(body: text)
  end
end
```

The `handle_reply` method takes a block with 4 parameters. The first one is the original object (in this case the comment). The second is the user who is sending the reply. The third is the reply plain text from the email (HTML mails are not supported). The fourth and last argument is an Array of `StringIO` objects representing all files attached to the emails.

What you put in the `handle_reply` block is completely up to you. In this example we are just creating a new comment, but you could also handle attached files by passing them to carrierwave, etc.

#### Make your mailer send the `reply_to` address

To add the unique reply address to your outgoing emails and make them 'replyable', add the reply_to option to your mailers methods:

```ruby
class CommentMailer < ActionMailer::Base
  def new_comment(user, comment)
    mail(to: user.email, reply_to: comment.reply_address_for_user(user))
  end
end
```

## Start up

Start/Stop up the Mailman background worker with the following commands:

```bash
$ RAILS_ENV=production script/mailman_daemon start
$ RAILS_ENV=production script/mailman_daemon stop
```
