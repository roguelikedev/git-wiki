require File.dirname(__FILE__) + "/helper"

context "The main application" do
  
  setup do
    @app = Sinatra.application
    @request = Rack::MockRequest.new(@app)
  end
  
  specify "should be defined with methods on main" do
    
    get '/' do
      'testing'      
    end
    
    response = @request.get('/')
    
    assert_equal(200, response.status)
    assert_equal('testing', response.body)
    
  end
  
end
