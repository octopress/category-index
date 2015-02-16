require 'octopress-ink'
require 'octopress-categories/version'
#require 'octopress-categories/page_asset'
require 'octopress-categories/filters'

module Octopress
  module Categories
    # Simple Page class override
    class CategoryPage < Jekyll::Page
      attr_accessor :dir, :name
      include Ink::Convertible
      
      def relative_asset_path
        site_source = Pathname.new Octopress.site.source
        page_source = Pathname.new @base
        page_source.relative_path_from(site_source).to_s
      end
    end
    
    class Plugin < Ink::Plugin

      attr_reader :category_pages

      def register
        super
        if Octopress::Ink.enabled?
          add_category_pages
        end
      end

      def add_category_pages

        # Find the correct template
        template = @includes.find { |l|
          l.file == "category_index.html"
        }

        created_pages = []
        if defined?(Octopress::Multilingual) && Octopress.site.config['lang']
          # We need to create pages for each language
          Octopress.site.languages.each do |lang|
            category_pages_lang = createCategoryPages(template, lang)
            created_pages.concat(category_pages_lang)
          end
        else
          created_pages = createCategoryPages(template)
        end
        

        Octopress.site.pages.concat(created_pages)
      end

      def createCategoryPages(template, lang=nil)
        categoryPages = []
        c = config(lang)
        categories = c['categories'] || Octopress.site.categories.keys
        categories.each do |category|
          page = CategoryPage.new(Octopress.site, File.dirname(template.path), '.', File.basename(template.path))
          page.data['category'] = category
          page.data['layout'] = config(lang)['layout']
          page.dir = category_dir(category, lang)
          page.data['lang'] = lang
          page.data['title'] = config(lang)['title'] + category
          page.process('index.html')

          categoryPages << page
        end
        categoryPages
      end

      def add_asset_files(options)
        options << "category-pages"
        super
      end

      def category_dir(category, lang=nil)
        category_base_dir = config(lang)['dir'].gsub(/^\/*(.*)\/*$/, '\1')
        File.join('/', lang || '', category_base_dir, slugifyCategory(category))
      end

      def slugifyCategory(category)
        category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').tr( '^A-Za-z0-9\-_', '-' ).downcase
      end
    end
  end
end

Octopress::Ink::Plugins.register_plugin(Octopress::Categories::Plugin, {
  name:          "Octopress Categories",
  slug:          "categories",
  gem:           "octopress-categories",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "..")),
  type:          "plugin",
  version:       Octopress::Categories::VERSION,
  description:   "Category pages for Octopress and Jekyll pages.",
  source_url:    "https://github.com/drallgood/octopress-categories",
  website:       "https://github.com/drallgood/octopress-categories"
})
