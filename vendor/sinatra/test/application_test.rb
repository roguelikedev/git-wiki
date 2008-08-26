require File.dirname(__FILE__) + "/helper"

context "A Sinatra::Application with one Event" do
  
  setup do
    @app = Sinatra::Application.new do
      use Sinatra::Application::Middleware::NotFoundHandler, errors
      get '/' do
       'hello world'
      end
    end
    
    @request = Rack::MockRequest.new(@app)
    @response = @request.get('/')
  end
  
  specify "should return 200 status if there is a valid Event" do
    assert_equal(200, @response.status)
  end
  
  specify "should return default headers" do
    assert_equal({ 'Content-Type' => 'text/html' }, @response.headers)
  end
    
  specify "should return blocks return value as the body" do
    assert_equal('hello world', @response.body)
  end
  
end

context "A Sinatra::Application with two Events" do

  setup do
    @app = Sinatra::Application.new do
      use Sinatra::Application::Middleware::NotFoundHandler, errors

      get '/' do
       'hello world'
      end

      get '/foo' do
       'in foo'
      end
    end
    
    @request = Rack::MockRequest.new(@app)
    @response = @request.get('/foo')
  end
  
  specify "should return 200 status if there is a valid Event" do
    assert_equal(200, @response.status)
  end
  
  specify "should return default headers" do
    assert_equal({ 'Content-Type' => 'text/html' }, @response.headers)
  end
    
  specify "should return blocks return value as the body" do
    assert_equal('in foo', @response.body)
  end
    
end

context "A Sinatra::Application with no Events that match request" do

  setup do
    @app = Sinatra::Application.new do
      use Sinatra::Application::Middleware::NotFoundHandler, errors

      get '/' do
       "you can't see me!"
      end
    end
    
    @request = Rack::MockRequest.new(@app)
    @response = @request.get('/asdf')
  end
  
  specify "should return 404 status" do
    assert_equal(404, @response.status)
  end
  
  specify "should return default headers" do
    assert_equal({ 'Content-Type' => 'text/html' }, @response.headers)
  end
    
  specify "should return blocks return value as the body" do
    assert_equal('<h1>Not Found</h1>', @response.body)
  end
    
end

context "A Sinatra::Application when falling" do
  
  specify "should preserve context" do
    @app = Sinatra::Application.new do
      get '/' do
        @foo = 'you got me'
        fall
      end
      
      get '/' do
        @foo
      end
    end
    
    @request = Rack::MockRequest.new(@app)
    @response = @request.get('/')
    assert_equal('you got me', @response.body)
  end
  
end


