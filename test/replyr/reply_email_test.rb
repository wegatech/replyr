# -*- encoding : utf-8 -*-
require_relative '../test_helper'

describe Replyr::ReplyEmail do
  it 'parses plain message object correctly' do
    mail = Mail.read('test/support/emails/reply_plain.eml')
    reply_email = Replyr::ReplyEmail.new(mail)
    assert_equal "wursttheke@me.com", reply_email.from
    assert_equal "Das ist wunderschön", reply_email.stripped_body
  end

  it 'parses multipart message object correctly' do
    mail = Mail.read('test/support/emails/reply_plain.eml')
    reply_email = Replyr::ReplyEmail.new(mail)
    assert_equal "wursttheke@me.com", reply_email.from
    assert_equal "Das ist wunderschön", reply_email.stripped_body
  end
end