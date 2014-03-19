class Comment < ActiveRecord::Base
  belongs_to :user

  handle_reply do |comment, user, text, files|
    Comment.create(body: text)
  end
end