require_relative '../test_helper'

setup_database

describe Replyr::HandleBounce do
  describe '#reply_address_object_for_user' do
    it 'returns reply address object' do
      @user1 = User.create
      @user2 = User.create
      @comment = Comment.create(user: @user1)
      
      address = @comment.reply_address_object_for_user(@user2)
      
      assert_kind_of Replyr::ReplyAddress, address
      assert_equal @comment, address.model
      assert_equal @user2, address.user
    end
  end

  describe '#reply_address_for_user' do
    it 'returns reply address string' do
      @user1 = User.create
      @user2 = User.create
      @comment = Comment.create(user: @user1)
      
      address = @comment.reply_address_for_user(@user2)
      
      assert_kind_of String, address
    end
  end
  
  describe '#handle_reply' do
    it 'receives the passed reply and calls block' do
      user1 = User.create
      user2 = User.create
      comment = Comment.create(user: @user1)

      old_count = Comment.count
      comment.handle_reply(@user2, "Ein neuer Kommentar")
      new_count = Comment.count
      
      assert_equal new_count, old_count + 1
    end
  end

end