require File.dirname(__FILE__) + '/helper'

context "Builder" do

  context "without layouts" do

    specify "should render" do

      filter = Sinatra::Filter.new do
        builder 'xml.instruct!'
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal(%(<?xml version="1.0" encoding="UTF-8"?>\n), response.body)

    end

    specify "should render inline block" do
  
      filter = Sinatra::Filter.new do
        @name = "Frank & Mary"
        builder do |xml|
          xml.couple @name
        end
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal(%(<couple>Frank &amp; Mary</couple>\n), response.body)

    end

  end



  context "Templates (in general)" do

    specify "are read from files if Symbols" do
  
      filter = Sinatra::Filter.new do
        @name = 'Blue'
        builder :foo, :views_directory => File.dirname(__FILE__) + "/views"
      end

      _, _, response = filter.call(context_for("/"))
      assert_equal(%(<exclaim>You rock Blue!</exclaim>\n), response.body)
        
    end
  
    specify "use layout.ext by default if available" do
  
      filter = Sinatra::Filter.new do
        builder :foo, :views_directory => File.dirname(__FILE__) + "/views/layout_test"
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal("<layout>\n<this>is foo!</this>\n</layout>\n", response.body)
  
    end
  
    specify "renders without layout" do
  
      filter = Sinatra::Filter.new do
        builder :no_layout, :views_directory => File.dirname(__FILE__) + "/views/no_layout"
      end
  
      _, _, response = filter.call(context_for("/"))
      assert_equal("<foo>No Layout!</foo>\n", response.body)
  
    end
  
    specify "raises error if template not found" do
  
      filter = Sinatra::Filter.new do
        builder :not_found
      end
  
      assert_raise(Errno::ENOENT) { filter.call(context_for("/")) }
  
    end

  end

end
