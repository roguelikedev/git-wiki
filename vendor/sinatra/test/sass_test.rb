require File.dirname(__FILE__) + '/helper'

context "Sass" do

  context "Templates (in general)" do

    specify "are read from files if Symbols" do

      filter = Sinatra::Filter.new do
        sass :foo, :views_directory => File.dirname(__FILE__) + "/views"
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("#sass {\n  background_color: #FFF; }\n", response.body)

    end
    
    specify "raise an error if template not found" do
      
      filter = Sinatra::Filter.new do
        sass :not_found
      end
    
      assert_raise(Errno::ENOENT) { filter.call(context_for("/")) }
      
    end
    
    specify "ignore default layout file with .sass extension" do
      
      filter = Sinatra::Filter.new do
        sass :foo, :views_directory => File.dirname(__FILE__) + "/views/layout_test"
      end
      
      _, _, response = filter.call(context_for("/"))
      assert_equal("#sass {\n  background_color: #FFF; }\n", response.body)
      
    end
    
    specify "ignore explicitly specified layout file" do
      
      filter = Sinatra::Filter.new do
        sass :foo, :layout => :layout, :views_directory => File.dirname(__FILE__) + "/views/layout_test"
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal("#sass {\n  background_color: #FFF; }\n", response.body)
      
    end
    
  end

end
