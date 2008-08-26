require File.dirname(__FILE__) + '/helper'

context "Erb" do

  context "without layouts" do
        
    specify "should render" do
    
      filter = Sinatra::Filter.new do
        erb '<%= 1 + 1 %>'
      end
    
      _, _, response = filter.call(context_for("/"))
      assert_equal("2", response.body)

    end

  end

  context "with locals" do
    
    specify "should expose them the template" do
      
      filter = Sinatra::Filter.new do
        erb '<%= foo %>', :locals => { :foo => "Bar" }
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("Bar", response.body)
    
    end
  
  end

  context "with layouts" do
  
    specify "can be inline" do

      templates = {
        :layout => "This is <%= yield %>!"
      }
    
      filter = Sinatra::Filter.new :templates => templates do
        erb 'Blake'
      end
    
      _, _, response = filter.call(context_for("/"))
      assert_equal("This is Blake!", response.body)
      
    end
    
    specify "can use named layouts" do
      
      templates = {
        :pretty => "X <%= yield %> X"
      }

      filter = Sinatra::Filter.new :templates => templates do
        erb 'foo', :layout => :pretty
      end
        
      _, _, response = filter.call(context_for("/"))
      assert_equal("X foo X", response.body)
    
    end

    specify "can be read from a file if they're not inlined" do
    
      filter = Sinatra::Filter.new do
        @title = 'Welcome to the Hello Program'
        erb 'Blake', :layout => :foo_layout,
                     :views_directory => File.dirname(__FILE__) + "/views"
      end
    
      _, _, response = filter.call(context_for("/"))
      assert_equal("Welcome to the Hello Program\nHi Blake\n", response.body)
    
    end
    
  end
  
  context "Templates (in general)" do
  
    specify "are read from files if Symbols" do
  
      filter = Sinatra::Filter.new do
        @name = 'Alena'
        erb :foo, :views_directory => File.dirname(__FILE__) + "/views"
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal("You rock Alena!", response.body)
  
    end
  
    specify "use layout.ext by default if available" do
  
      filter = Sinatra::Filter.new do
        erb :foo, :views_directory => File.dirname(__FILE__) + "/views/layout_test"
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal("x This is foo! x \n", response.body)
  
    end
  
  end
  
end
