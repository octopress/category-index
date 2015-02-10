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
        name = slugifyCategory
        if lang
          name = "#{name}-#{lang}"
        end
        name
      end

      def permalink
        link = "/#{category_dir}/"
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
      def category_dir
        category_base_dir = plugin.config['category_dir'].gsub(/^\/*(.*)\/*$/, '\1')
        File.join(category_base_dir, slugifyCategory)
      end

      def slugifyCategory
        category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').tr( '^A-Za-z0-9\-_', '-' ).downcase
      end
    end
  end
end
