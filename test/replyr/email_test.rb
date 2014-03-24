# -*- encoding : utf-8 -*-
require_relative '../test_helper'
require 'mail'

describe Replyr::Email do
  describe "#new" do
    it 'parses plain message object correctly' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/reply_plain.eml'))
      assert_equal "wursttheke@me.com", email.from
      assert_equal "Das ist wunderschön", email.stripped_body
    end

    it 'parses multipart message object correctly' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/reply_multipart.eml'))
      assert_equal "wursttheke@me.com", email.from
      assert_equal "Das ist wunderschön", email.stripped_body
    end

    it 'removes signature from message object' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/reply_plain_signature.eml'))
      assert_equal "wursttheke@me.com", email.from
      assert_equal "Das ist wunderschön", email.stripped_body
    end

  end  
  
  describe '#is_bounce_email?' do
    it 'returns true for a bounce mail (failed)' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/bounce_530.eml'))
      assert_equal true, email.is_bounce_email?
    end
    
    it 'returns false for a bounce mail (temporary failure)' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/bounce_422.eml'))
      assert_equal false, email.is_bounce_email?
    end
      
    it 'returns false for a normal mail' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/reply_plain.eml'))
      assert_equal false, email.is_bounce_email?
    end
  end

  describe '#failed_permanently?' do
    it 'returns true for a bounce mail of type 5.x.x' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/bounce_530.eml'))
      assert_equal true, email.failed_permanently?
    end
    
    it 'returns true for a bounce mail of type 4.x.x' do
      email = Replyr::Email.new(Mail.read('test/replyr/emails/bounce_422.eml'))
      assert_equal false, email.failed_permanently?
    end
  end
  
  describe '#process' do
    it 'returns false if mail is invalid' do
      mail = Mail.read('test/replyr/emails/reply_plain.eml')
      email = Replyr::Email.new(mail)
      assert_equal false, email.process
    end
    
    it "processes mail if it's valid and return true" do
      address = Replyr::ReplyAddress.new(Comment.create, User.create).address
      mail = Mail.read('test/replyr/emails/reply_plain.eml')
      mail.to = address # set correct address
      email = Replyr::Email.new(mail)

      assert true, email.is_reply_email?

      comment_count = Comment.count
      assert_equal true, email.process
      assert_equal comment_count + 1, Comment.count
    end
  end
  

end