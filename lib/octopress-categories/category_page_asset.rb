module Octopress
  module Categories
    class CategoryPageAsset < Ink::Assets::PageAsset

      attr_accessor :category

      def initialize(plugin, template, category)
        super(plugin, template.base, template.file)
        self.category = category
      end

      def clone(plugin, template, category)
        p = CategoryPageAsset.new(plugin, template, category)
        p
      end

      def copy(target_dir)
        # Don't copy anything
      end

      def info
        message = super
        name = permalink_name << page.ext
        message.sub!(/#{name}\s*/, permalink_name.ljust(35))
        message.sub!(/#{filename}\s*/, filename.ljust(35))
        message.sub!(/\.\/#{filename}*/, "#{@plugin.slug}/layouts/#{filename}")
        message
      end

      def permalink_name
        name = plugin.slugifyCategory(category)
        if lang
          name = "#{name}-#{lang}"
        end
        name
      end

      def permalink
        link = "/#{plugin.category_dir}/"
        if lang
          link = "/#{lang}#{link}"
        end
        link
      end

      def category=(category)
        title_prefix = plugin.config['prefixes']['title'] || 'Category: '
        meta_description_prefix = plugin.config['prefixes']['meta_description'] || 'Category: '
        @data.merge!({
                       "category"=>category,
                       "title"=>"#{title_prefix}#{category.capitalize}",
                       "description"=>"#{meta_description_prefix}#{category.capitalize}"
        })
        @category = category
      end

      private

      def lang
        data['lang']
      end
    end
  end
end
