# -*- encoding : utf-8 -*-
require_relative '../test_helper'
require 'mail'

describe Replyr::ReplyEmail do
  describe "#new" do
    it 'parses plain message object correctly' do
      mail = Mail.read('test/replyr/emails/reply_plain.eml')
      reply_email = Replyr::ReplyEmail.new(mail)
      assert_equal "wursttheke@me.com", reply_email.from
      assert_equal "Das ist wunderschön", reply_email.stripped_body
    end

    it 'parses multipart message object correctly' do
      mail = Mail.read('test/replyr/emails/reply_multipart.eml')
      reply_email = Replyr::ReplyEmail.new(mail)
      assert_equal "wursttheke@me.com", reply_email.from
      assert_equal "Das ist wunderschön", reply_email.stripped_body
    end

    it 'removes signature from message object' do
      mail = Mail.read('test/replyr/emails/reply_plain_signature.eml')
      reply_email = Replyr::ReplyEmail.new(mail)
      assert_equal "wursttheke@me.com", reply_email.from
      assert_equal "Das ist wunderschön", reply_email.stripped_body
    end

  end  
  
  describe '#process' do
    it 'returns false if mail is invalid' do
      mail = Mail.read('test/replyr/emails/reply_plain.eml')
      reply_email = Replyr::ReplyEmail.new(mail)
      assert_equal false, reply_email.process
    end
    
    it "processes mail if it's valid and return true" do
      address = Replyr::ReplyAddress.new(Comment.create, User.create).address
      mail = Mail.read('test/replyr/emails/reply_plain.eml')
      mail.to = address # set correct address
      reply_email = Replyr::ReplyEmail.new(mail)

      assert true, reply_email.is_reply_email?

      comment_count = Comment.count
      assert_equal true, reply_email.process
      assert_equal comment_count + 1, Comment.count
    end
    
  end
end