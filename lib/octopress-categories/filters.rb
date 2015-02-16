module Octopress
  module Categories
    module Filters
      # Outputs a list of categories as comma-separated <a> links. This is used
      # to output the category list for each post on a category page.
      #
      #  +categories+ is the list of categories to format.
      #
      # Returns string
      def category_links(categories)
        plugin = Ink::Plugins.plugin("categories")
        root = @context.registers[:site].baseurl
        language = @context.registers[:page]['lang']


        categories = categories.sort!.map do |category|
          category_dir = plugin.category_dir(category, language)
          "<a class='category' href='#{root}#{category_dir}/'>#{category.capitalize}</a>"
        end

        case categories.length
        when 0
          ""
        when 1
          categories[0].to_s
        else
          categories.join(', ')
        end
      end
    end
  end
end
Liquid::Template.register_filter(Octopress::Categories::Filters)
