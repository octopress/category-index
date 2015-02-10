module Octopress
  module Categories
    class CategoryPageAsset < Ink::Assets::PageAsset

      attr_accessor :category

      def initialize(plugin, template, category)
        super(plugin, template.base, template.file)
        @category = category
      end


      def clone(permalink_name, permalink, data={})
        p = CategoryPageAsset.new(plugin, base, file)
        p.permalink_name = permalink_name
        p.permalink ||= permalink
        p.data.merge!(data)
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

      def ext
        ""
      end

      private

      def lang
        data['lang']
      end
      def category_dir
        category_base_dir = @plugin.config['category_dir'].gsub(/^\/*(.*)\/*$/, '\1')
        File.join(category_base_dir, slugifyCategory)
      end

      def slugifyCategory
        @category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').tr( '^A-Za-z0-9\-_', '-' ).downcase
      end
    end
  end
end
