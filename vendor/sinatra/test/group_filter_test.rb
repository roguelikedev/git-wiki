require File.dirname(__FILE__) + "/helper"

context "Filters when falling" do

  specify "should fall through to the next app" do
    
    app = Sinatra::Application.new do
      
      filter do
        @foo = 'foo'
        fall
      end
      
      group do
        
        filter do
          @foo
        end
        
      end

    end
    
    assert_equal(2, app.filters.size)
    assert_equal(1, app.filters.last.filters.size)
    
    request   = Rack::MockRequest.new(app)
    response  = request.get('/')
    
    assert_equal(200, response.status)
    assert_equal('foo', response.body)
    
  end


  specify "should 404 if the app bottoms-out" do
    
    app = Sinatra::Application.new do
      
      filter do
        @foo = 'foo'
        fall
      end
      
      group do
        
        filter do
          @foo
          fall
        end
        
      end

    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/')
    
    assert_equal(99, response.status)
    
  end

  specify "should be successful falls from inner app and hits good filter" do
    
    app = Sinatra::Application.new do
            
      group do
        
        filter do
          @foo = 'inner foo'
          fall
        end
        
      end
      
      filter do
        @foo
      end

    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/')
    
    assert_equal(200, response.status)
    assert_equal('inner foo', response.body)
    
  end

  specify "should be successful when falling through to next app" do
    
    app = Sinatra::Application.new do
            
      group do
        
        filter do
          @foo = 'inner foo'
          fall
        end
        
      end
      
      filter do
        @foo
      end

    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/')
    
    assert_equal(200, response.status)
    assert_equal('inner foo', response.body)
    
  end

  specify "should be successful when falling through to next app" do
    
    app = Sinatra::Application.new do
            
      group do
        
        filter do
          @foo = 'inner foo'
          fall_group
        end
        
        filter do
          @foo = 'not it'
        end
        
      end
      
      filter do
        @foo
      end

    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/')
    
    assert_equal(200, response.status)
    assert_equal('inner foo', response.body)
    
  end

  specify "should pass options to filters" do
    
    app = Sinatra::Application.new :foo => "ASDF" do
      
      group :foo => 'bar' do
                
        filter do
          options[:foo]
        end
        
      end
      
    end

    request   = Rack::MockRequest.new(app)
    response  = request.get('/')
    
    assert_equal('bar', response.body)
    
  end

end
