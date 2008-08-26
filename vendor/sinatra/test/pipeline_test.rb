require File.dirname(__FILE__) + "/helper"

class MyMiddleware
  def initialize(app)
    @app = app
  end
  
  def call(env)
    env['test_var'] = 'X'
    @app.call(env)
  end
  
end

context "The pipeline" do
  
  specify "should execute middleware leading app" do
    app = Sinatra::Application.new do
      use MyMiddleware
      get '/' do
        request.env['test_var']
      end
    end
    response = Rack::MockRequest.new(app).get('/')
    assert_equal('X', response.body)
  end

end