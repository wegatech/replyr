class User < ActiveRecord::Base
  has_many :comments
  
  handle_bounce do |user, email|
    user.update_attribute(:email_valid, false)
  end

end