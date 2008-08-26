require File.dirname(__FILE__) + "/helper"

context "Filters with a host filter" do
  
  specify "should match on the host" do
    app = Sinatra::Application.new do
      for_host 'foo.bar.com' do
        filter do
          'got it'
        end
      end
      filter do
        'not it'
      end
    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/', "HTTP_HOST" => 'foo.bar.com')
    
    assert_equal(200, response.status)
    assert_equal('got it', response.body)
  end

  specify "should have access to matches" do
    app = Sinatra::Application.new do
      for_host /(.*?)\..*/ do
        filter do
          host
        end
      end
    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/', "HTTP_HOST" => 'foo.bar.com')
    
    assert_equal(200, response.status)
    assert_equal('foo', response.body)
  end

  specify "should not execute block if no match" do
    app = Sinatra::Application.new do
      for_host /foo.bar.com/ do
        filter do
          'no match'
        end
      end
      filter do
        'hit'
      end
    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/', "HTTP_HOST" => 'not.bar.com')
    
    assert_equal(200, response.status)
    assert_equal('hit', response.body)
  end
  
  
end