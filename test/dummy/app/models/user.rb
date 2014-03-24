class User < ActiveRecord::Base
  has_many :comments
  
  handle_bounce do |user, email|
    user.update_attributes({email_invalid: true})
  end

end