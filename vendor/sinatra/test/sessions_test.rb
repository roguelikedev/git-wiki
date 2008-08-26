require File.dirname(__FILE__) + '/helper'

context "Sessions" do

  specify "should be off by default" do
    
    app = Sinatra::Application.new do
      enable :sessions
    end
    
    assert_equal(Rack::Session::Cookie, app.send(:middleware).first.first)
  end
  
end
