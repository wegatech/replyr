require_relative '../test_helper'

setup_database

describe Replyr::BounceAddress do
  describe '#new' do
    it 'returns new address' do
      @user = User.create

      address = Replyr::BounceAddress.new(@user)
      assert_kind_of Replyr::BounceAddress, address
      assert_equal @user, address.model
    end

  end

  describe '#new_from_address' do
    it 'returns new instance if address is valid' do
      user = User.create
      correct_address = Replyr::BounceAddress.new(user).address
      address = Replyr::BounceAddress.new_from_address(correct_address)
      assert_kind_of Replyr::BounceAddress, address
      assert_equal user.id, address.model.id
      assert_equal user.class.name, address.model.class.name
    end
    
    it 'return nil if email address is malformed (no reply email)' do
      assert_equal nil, Replyr::BounceAddress.new_from_address("malformed@example.com")
    end
    
    it 'returns nil if addreess is invalid' do
      assert_equal nil, Replyr::BounceAddress.new_from_address("reply-comment-1-1-wrongtoken@example.com")
    end
  end
  
  describe '#token_valid?' do
    before do
      @address = Replyr::BounceAddress.new(User.create)
    end

    it 'return true if the passed token is valid' do
      assert_equal true, @address.token_valid?(@address.token)
    end

    it 'return false if the passed token is valid' do
      assert_equal false, @address.token_valid?("wrong_token")
    end
  end

  describe '#ensure_valid_token!' do
    before do
      @address = Replyr::BounceAddress.new(User.create)
    end

    it 'throws exception if token is invalid' do
      assert_raises RuntimeError do
        @address.ensure_valid_token!("wrong_token")
      end
    end

    it 'throws exception if token is invalid' do
      assert_equal nil, @address.ensure_valid_token!(@address.token)
    end
  end
  
  describe '#token' do
    before do
      @user1 = User.create
      @user2 = User.create
    end
    
    it 'returns an auth token' do
      address = Replyr::BounceAddress.new(@user1)
      assert_kind_of String, address.token
    end
    
    it 'return the same auth token for same arguments' do
      address1 = Replyr::BounceAddress.new(@user2)
      address2 = Replyr::BounceAddress.new(@user2)
      assert_equal address1.token, address2.token
    end

    it 'return a different auth token for different user' do
      address1 = Replyr::BounceAddress.new(@user1)
      address2 = Replyr::BounceAddress.new(@user2)
      refute_equal address1.token, address2.token
    end
    
  end

end