require File.dirname(__FILE__) + '/test_helper'

class TestSubmission < Test::Unit::TestCase
  before do
    @client = Wufoo::Client.new('http://foobar.wufoo.com', 'somecrazyapikey')
  end
  
  test 'initialize' do
    submission = Wufoo::Submission.new(@client, 'my-crazy-form')
    assert_equal(@client, submission.client)
    assert_equal('my-crazy-form', submission.form)
    assert_equal({}, submission.params)
  end
  
  test 'initialize with params' do
    submission = Wufoo::Submission.new(@client, 'my-crazy-form', {'0' => 'Foo'})
    assert_equal({'0' => 'Foo'}, submission.params)
  end
  
  test 'add_params' do
    submission = Wufoo::Submission.new(@client, 'my-crazy-form').add_params('0' => 'Foo')
    assert_equal({'0' => 'Foo'}, submission.params)
  end
  
  test 'add_params returns self' do
    assert_kind_of(Wufoo::Submission, Wufoo::Submission.new(@client, 'my-crazy-form').add_params('0' => 'Foo'))
  end
  
  context 'processing response that was successful' do
    before do
      @client.stub!(:post, :return => successful_response_data)
      submission = Wufoo::Submission.new(@client, 'my-crazy-form').add_params({'0' => 'Foobar!'})
      @response = submission.process
    end
    
    test 'should have data' do
      assert_equal(successful_response_data, @response.data)
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
      @client.stub!(:post, :return => error_response_data)
      submission = Wufoo::Submission.new(@client, 'my-crazy-form').add_params({'0' => 'Foobar!'})
      @response = submission.process
    end
    
    test 'should have data' do
      assert_equal(error_response_data, @response.data)
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
      @client.stub!(:post, :return => field_error_response_data)
      submission = Wufoo::Submission.new(@client, 'my-crazy-form').add_params({'0' => 'Foobar!'})
      @response = submission.process
    end
    
    test 'should have data' do
      assert_equal(field_error_response_data, @response.data)
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