require File.dirname(__FILE__) + '/helper'

require "pp"

context "Haml" do
  
  context "without layouts" do
    
    specify "should render" do

      filter = Sinatra::Filter.new :templates => {} do
        haml '== #{1+1}'
      end
    
      _, _, response = filter.call(context_for("/"))
      
      assert_equal("2\n", response.body)
    end
  end
  
  context "with layouts" do
  
    specify "can be inline" do
      options = { :templates => { :layout => "X\n= yield\nX" } }
      
      filter = Sinatra::Filter.new(options) do
        haml 'foo'
      end
    
      _, _, response = filter.call(context_for("/"))
      assert_equal("X\nfoo\nX\n", response.body)
    end

    specify "can use named layouts" do
    
      templates = {
        :pretty => "X\nbar\nX\n"
      }

      filter = Sinatra::Filter.new :templates => templates do
        haml 'bar', :layout => :pretty
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("X\nbar\nX\n", response.body)

    end
  
    specify "can be read from a file if they're not inlined" do
    
      filter = Sinatra::Filter.new do
        @title = 'Welcome to the Hello Program'
        haml 'Blake', :layout => :foo_layout,
                      :views_directory => File.dirname(__FILE__) + "/views"
      end
    
      _, _, response = filter.call(context_for("/"))
      assert_equal("Welcome to the Hello Program\nHi Blake\n", response.body)
          
    end
    
    specify "can be read from file and layout from text" do

      filter = Sinatra::Filter.new do
        haml 'Test', :layout => '== Foo #{yield}'
      end
      
      _, _, response = filter.call(context_for("/"))
      assert_equal("Foo Test\n", response.body)

    end
  
  end

  context "Templates (in general)" do

    specify "are read from files if Symbols" do

      filter = Sinatra::Filter.new do
        @name = 'Alena'
        haml :foo, :views_directory => File.dirname(__FILE__) + "/views"
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("You rock Alena!\n", response.body)

    end

    specify "use layout.ext by default if available" do
  
      filter = Sinatra::Filter.new do
        haml :foo, :views_directory => File.dirname(__FILE__) + "/views/layout_test"
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal("x This is foo!\n x\n", response.body)
  
    end
  
    specify "renders without layout" do
  
      filter = Sinatra::Filter.new do
        haml :no_layout, :views_directory => File.dirname(__FILE__) + "/views/no_layout"
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal("<h1>No Layout!</h1>\n", response.body)
  
    end
    
    specify "can use named layouts" do
    
      templates = {
        :layout => "X\nbar\nX\n"
      }

      filter = Sinatra::Filter.new :templates => templates do
        haml 'bar', :layout => false
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("bar\n", response.body)

    end

    specify "raises error if template not found" do
      filter = Sinatra::Filter.new do
        haml :not_there
      end

    assert_raise(Errno::ENOENT) { filter.call(context_for("/")) }

    end

    specify "use layout.ext by default if available" do

      templates = {
        :foo => 'asdf'
      }

      filter = Sinatra::Filter.new :templates => templates do
        haml :foo, :layout => false,
                   :views_directory => File.dirname(__FILE__) + "/views/layout_test"
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("asdf\n", response.body)

    end
    
  end
  
  describe 'Options passed to the HAML interpreter' do
  
    specify 'are empty be default' do
      
      filter = Sinatra::Filter.new do
        haml 'foo'
      end
      
      Haml::Engine.expects(:new).with('foo', {}).returns(stub(:render => 'foo'))
      
      filter.call(context_for("/"))
      
    end
  
    specify 'can be configured by passing :options to haml' do
  
      filter = Sinatra::Filter.new do
        haml 'foo', :options => {:format => :html4}
      end
  
      Haml::Engine.expects(:new).with('foo', {:format => :html4}).returns(stub(:render => 'foo'))
  
      filter.call(context_for('/'))
      
    end
  
  end

end
