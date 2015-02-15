require 'octopress-ink'
require 'octopress-categories/version'
require 'octopress-categories/page_asset'
require 'octopress-categories/filters'

module Octopress
  module Categories
    class Plugin < Ink::Plugin

      attr_reader :category_pages

      def initialize(options)
        super
        @category_pages = []
      end

      def register
        super
        unless @assets_path.nil?
          if Octopress::Ink.enabled?
            add_category_pages
          end
        end
      end

      def assets
        superAssets = super
        superAssets.merge!({
                             "category-pages" => @category_pages
        })
      end

      def add_category_pages

        # Find the correct template
        template = @includes.detect { |l|
          l.file == "category_index.html"
        }

        created_pages = []
        if defined? Octopress::Multilingual
          # We need to create pages for each language
          Octopress.site.languages.each do |lang|
            category_pages_lang = createCategoryPages(template, config(lang))
            category_pages_lang.each { |p|
              p.data.merge!({"lang"=>lang})
            }
            created_pages.concat(category_pages_lang)
          end
        else
          created_pages = createCategoryPages(template, config)
        end

        @category_pages.concat(created_pages)
      end

      def createCategoryPages(template, config)
        categoryPages = []
        Octopress.site.categories.keys.each do |category|
          categoryPages << CategoryPageAsset.new(self, template, category)
        end
        categoryPages
      end

      def add_asset_files(options)
        options << "category-pages"
        super
      end

      def category_dir(category)
        category_base_dir = config['category_dir'].gsub(/^\/*(.*)\/*$/, '\1')
        # Make sure the category directory begins with a slash.
        category_base_dir = "/#{category_base_dir}" unless category_base_dir =~ /^\//
        File.join(category_base_dir, slugifyCategory(category))
      end

      def slugifyCategory(category)
        category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').tr( '^A-Za-z0-9\-_', '-' ).downcase
      end
    end
  end
end

#Octopress::Ink.add_plugin({
Octopress::Ink::Plugins.register_plugin(Octopress::Categories::Plugin,{
                                          name:          "Octopress Categories",
                                          slug:          "categories",
                                          gem:           "octopress-categories",
                                          path:          File.expand_path(File.join(File.dirname(__FILE__), "..")),
                                          type:          "plugin",
                                          version:       Octopress::Categories::VERSION,
                                          description:   "Category pages for Octopress and Jekyll pages.",                                # What does your theme/plugin do?
                                          source_url:    "https://github.com/drallgood/octopress-categories",
                                          website:       "https://github.com/drallgood/octopress-categories"                                 # Optional project website
})
