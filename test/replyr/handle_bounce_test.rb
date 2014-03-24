require_relative '../test_helper'

setup_database

describe Replyr::HandleBounce do
  describe '#bounce_address_object' do
    it 'returns bounce return_path address object' do
      @user = User.create
      address = @user.bounce_address_object
      assert_kind_of Replyr::BounceAddress, address
      assert_equal @user, address.model
    end
  end

  describe '#bounce_address' do
    it 'returns bounce return_path address string' do
      @user = User.create
      address = @user.bounce_address
      assert_kind_of String, address
    end
  end
  
  describe '#handle_bounce' do
    it 'receives the passed reply and calls block' do
      user = User.create(email: "test@example.com")
      assert_equal false, user.email_invalid?
      user.handle_bounce(user.email)
      new_count = Comment.count
      assert_equal true, user.email_invalid?
    end
  end

end