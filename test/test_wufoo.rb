require File.dirname(__FILE__) + '/test_helper'

class TestWufoo < Test::Unit::TestCase
  before do
    @successful_response_data = {
      "wufoo_submit" => [{
        "confirmation_message" => "Success! Thanks for filling out my form!",
        "entry_id"             => "1025",
        "success"              => "true"
      }]
    }
    
    @error_response_data = {
      "wufoo_submit" => [{
        "error"        => "The supplied form URL was not found.",
        "field_errors" => [],
        "success"      => "false"
      }]
    }
    
    @field_error_response_data = {
      "wufoo_submit" => [{
        "error" => "",
        "field_errors" => [
          {"field_id" => "field0", "error_message" => "Invalid email address.", "error_code" => "2"},
          {"field_id" => "field1", "error_message" => "Field is required.", "error_code" => "0"},
        ],
        "success" => "false"
      }]
    }
  end
  
  test 'initialize' do
    wufoo = Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form')
    assert_equal('http://dummy.wufoo.com', wufoo.url)
    assert_equal('foobar', wufoo.api_key)
    assert_equal('my-crazy-form', wufoo.form)
    assert_equal({}, wufoo.params)
  end
  
  test 'initialize with params' do
    wufoo = Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form', {'0' => 'Foo'})
    assert_equal({'0' => 'Foo'}, wufoo.params)
  end
  
  test 'add_params' do
    wufoo = Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form').add_params('0' => 'Foo')
    assert_equal({'0' => 'Foo'}, wufoo.params)
  end
  
  test 'add_params returns self' do
    assert_kind_of(Wufoo, Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form').add_params('0' => 'Foo'))
  end
  
  context 'processing response that was successful' do
    before do
      Wufoo.stub!(:post, :return => @successful_response_data)
      wufoo = Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form').add_params({'0' => 'Foobar!'})
      @response = wufoo.process
    end
    
    test 'should have data' do
      assert_equal(@successful_response_data, @response.data)
    end
    
    test 'should be success?' do
      assert @response.success?
    end
    
    test 'should not be fail?' do
      assert ! @response.fail?
    end
    
    test 'should be valid?' do
      assert @response.valid?
    end
    
    test 'should have message' do
      assert_equal('Success! Thanks for filling out my form!', @response.message)
    end
    
    test 'should have entry_id' do
      assert_equal('1025', @response.entry_id)
    end
    
    test 'should not have error' do
      assert_equal('', @response.error)
    end
    
    test 'should not have errors' do
      assert_equal([], @response.errors)
    end
  end
  
  context 'processing a response that failed' do
    before do
      Wufoo.stub!(:post, :return => @error_response_data)
      wufoo = Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form').add_params({'0' => 'Foobar!'})
      @response = wufoo.process
    end
    
    test 'should have data' do
      assert_equal(@error_response_data, @response.data)
    end
    
    test 'should not be success?' do
      assert ! @response.success?
    end
    
    test 'should be a fail?' do
      assert @response.fail?
    end
    
    test 'should be valid?' do
      assert @response.valid?
    end

    test 'should have error' do
      assert_equal('The supplied form URL was not found.', @response.error)
    end
  end
  
  context 'processing a response with field errors' do
    before do
      Wufoo.stub!(:post, :return => @field_error_response_data)
      wufoo = Wufoo.new('http://dummy.wufoo.com', 'foobar', 'my-crazy-form').add_params({'0' => 'Foobar!'})
      @response = wufoo.process
    end
    
    test 'should have data' do
      assert_equal(@field_error_response_data, @response.data)
    end
    
    test 'should not be success?' do
      assert ! @response.success?
    end
    
    test 'should not be fail?' do
      assert ! @response.fail?
    end
    
    test 'should not be valid?' do
      assert ! @response.valid?
    end
    
    test 'should have errors' do
      field_ids = ['field0', 'field1']
      messages = ['Invalid email address.', 'Field is required.']
      codes = ['2', '0']
      assert_equal(field_ids, @response.errors.collect { |e| e.field_id })
      assert_equal(messages, @response.errors.collect { |e| e.message })
      assert_equal(codes, @response.errors.collect { |e| e.code })
    end
  end        
end