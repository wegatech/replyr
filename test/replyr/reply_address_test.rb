require_relative '../test_helper'

setup_database

describe Replyr::ReplyAddress do
  describe '#new' do
    it 'returns new address' do
      @user = User.create
      @comment = Comment.create

      address = Replyr::ReplyAddress.new(@comment, @user)
      assert_kind_of Replyr::ReplyAddress, address
      assert_equal @comment, address.model
      assert_equal @user, address.user
    end

  end

  describe '#new_from_address' do
    it 'returns new instance if address is valid' do
      user = User.create
      comment = Comment.create
      correct_address = Replyr::ReplyAddress.new(comment, user).address
      address = Replyr::ReplyAddress.new_from_address(correct_address)
      assert_kind_of Replyr::ReplyAddress, address
      assert_equal comment.id, address.model.id
      assert_equal comment.class.name, address.model.class.name
      assert_equal user.id, address.user.id
      assert_equal user.class.name, address.user.class.name
    end
    
    it 'raises ArgumentError if email address is malformed (no reply email)' do
      assert_raises ArgumentError do
        Replyr::ReplyAddress.new_from_address("malformed@example.com")
      end
    end
    
    it 'returns nil if addreess is invalid' do
      address = Replyr::ReplyAddress.new_from_address("reply-comment-1-1-wrongtoken@example.com")
      assert_equal nil, address
    end
  end
  
  describe '#token' do
    before do
      @user1 = User.create
      @user2 = User.create
      @comment1 = Comment.create
      @comment2 = Comment.create
    end
    
    it 'returns an auth token' do
      address = Replyr::ReplyAddress.new(@comment1, @user1)
      assert_kind_of String, address.token
    end
    
    it 'return the same auth token for same arguments' do
      address1 = Replyr::ReplyAddress.new(@comment1, @user2)
      address2 = Replyr::ReplyAddress.new(@comment1, @user2)
      assert_equal address1.token, address2.token
    end

    it 'return a different auth token for different model' do
      address1 = Replyr::ReplyAddress.new(@comment2, @user1)
      address2 = Replyr::ReplyAddress.new(@comment1, @user1)
      refute_equal address1.token, address2.token
    end

    it 'return a different auth token for different user' do
      address1 = Replyr::ReplyAddress.new(@comment1, @user1)
      address2 = Replyr::ReplyAddress.new(@comment1, @user2)
      refute_equal address1.token, address2.token
    end
    
  end

end