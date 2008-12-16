require File.dirname(__FILE__) + '/test_helper'

class TestWufoo < Test::Unit::TestCase
  test 'should have version' do
    assert_not_nil Wufoo::Version
  end
end