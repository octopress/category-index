module Octopress
  module Categories
    class CategoriesTag < Liquid::Tag
      def initialize(tag, input, tokens)
        super
        @plugin = Ink::Plugins.plugin("categories")
        @tag    = tag
        if !input.nil?
          @input  = input.strip
        end
      end

      def render(context)
        @context = context

        # If no input is passed, render in context of current page
        # This allows the tag to be used without input on post templates
        # But in a page loop it should be told passed the post item
        #

        item = context[@input] || context['page']
        categories = item['categories']

        return '' if categories.nil? || categories.empty?

        categories = categories.sort.map do |category|
          link = category_link(item, category)

          if category_list?
            link = "<li class='category-list-item'>#{link}</li>"
          end

          link
        end

        if category_list?
          "<ul class='category-list'>#{categories.join()}</ul>"
        else
          "<span class='category-links'>#{categories.join(', ')}</span>"
        end
      end

      def category_list?
        @tag == 'category_list'
      end

      def category_link(item, category)
        category_dir = @plugin.category_dir(category, item['lang'])
        path = File.join(@context['site']['baseurl'], category_dir)
        "<a class='category-link' href='#{path}/'>#{category}</a>"
      end
    end
  end
end

Liquid::Template.register_tag('categories', Octopress::Categories::CategoriesTag)
Liquid::Template.register_tag('category_list', Octopress::Categories::CategoriesTag)
