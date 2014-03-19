require_relative '../test_helper'

describe Replyr::ReplyEmail do
  it 'clears out invalid UTF-8 bytes' do
    body = "hello joel\255".force_encoding('UTF-8')

    # replace_name(body, 'hank').should_not raise_error(ArgumentError)
    # replace_name(body, 'hank').should eq "hello hank"
  end
end