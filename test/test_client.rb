require File.dirname(__FILE__) + '/test_helper'

class TestClient < Test::Unit::TestCase
  test 'initialize' do
    client = Wufoo::Client.new('http://foobar.wufoo.com', 'somecrazyapikey')
    assert_equal('http://foobar.wufoo.com', client.url)
    assert_equal('somecrazyapikey', client.api_key)
  end  
end