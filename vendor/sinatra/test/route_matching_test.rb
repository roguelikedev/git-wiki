require File.dirname(__FILE__) + "/helper"

context "Routes" do
  
  specify "should match explicit paths" do
    app = Sinatra::Application.new do
      get '/foo' do
        'hi'
      end
    end
    
    status, _ = app.call(context_for('/foo'))
    assert_equal(200, status)
  end

  specify "should match explicit paths with spaces" do
    app = Sinatra::Application.new do
      get('/foo bar') { 'hi' }
    end
    status, _ = app.call(context_for('/foo%20bar'))
    assert_equal(200, status)
  end
  
end

context "Routes with params" do

  specify "should match variables in paths" do
    app = Sinatra::Application.new do 
      get('/foo/:bar') {}
    end
    status, _ = app.call(context_for('/foo/baz'))
    assert_equal(200, status)
  end
  
  specify "should expose values of route params" do
    app = Sinatra::Application.new do
      get('/foo/:bar') { params['bar'] }
    end
    status, _, response = app.call(context_for('/foo/baz'))
    assert_equal('baz', response.body)
  end
    
end