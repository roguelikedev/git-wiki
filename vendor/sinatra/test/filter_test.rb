require File.dirname(__FILE__) + "/helper"

context "Filters when falling" do

  specify "returns 200 by default" do

    filter = Sinatra::Filter.new do
      'hi'
    end

    status, _, _ = filter.call(context_for("/"))

    assert_equal(200, status)
    
  end

  specify "does not touch headers by default" do

    filter = Sinatra::Filter.new do
      'hi'
    end

    _, headers, _ = filter.call(context_for("/"))

    ## This header is the default header entered by Rack
    assert_equal({'Content-Type' => 'text/html'}, headers)
    
  end
  
  specify "sets the body to the return value of the block" do
    
    filter = Sinatra::Filter.new do
      'hi'
    end
    
    _, _, response = filter.call(context_for("/"))
    
    assert_equal('hi', response.body)
    
  end
  
  
  specify "gets it's daily meta" do
    
    filter = Sinatra::Filter.new :foo => 'foo' do
      options[:foo]
    end
    
    _, _, response = filter.call(context_for("/"))
    
    assert_equal('foo', response.body)
    
  end
  
end
