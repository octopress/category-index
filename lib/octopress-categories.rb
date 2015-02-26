require 'octopress-ink'
require 'octopress-categories/version'
require 'octopress-categories/tags'

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

      def register
        super
        if Octopress::Ink.enabled?
          add_category_pages
        end
      end

      def add_category_pages

        # Find the correct template
        template = @templates.find { |l|
          l.file == "category_index.html"
        }

        @category_pages = []
        if defined?(Octopress::Multilingual) && Octopress.site.config['lang']
          # Ensure multilingual pages are set up for `ink list` view
          Octopress.site.read if Octopress.site.posts.empty?
          
          # We need to create pages for each language
          Octopress.site.languages.each do |lang|
            @category_pages.concat(createCategoryPages(template, lang))
          end
        else
          @category_pages = createCategoryPages(template)
        end

        Octopress.site.pages.concat(@category_pages)
      end

      def assets_list(options)
        message = super
        message << category_pages_list
      end

      def category_pages_list
        pages = @category_pages.group_by {|p| p.data['lang'] }
        message = ""
        pages.each do |lang, pages|
          message << " Category indexes:"

          if multilingual?
            message << (lang.nil? ? '' : " (#{Octopress::Multilingual.language_name(lang)})")
          end

          message << "\n"

          pages.each do |page|
            message << "  - #{page.data['category'].ljust(35)} #{page.path.sub('index.html', '')}\n"
          end

          message << "\n"
        end

        message
      end

      def createCategoryPages(template, lang=nil)
        categoryPages = []
        lang = nil unless multilingual?
        config = self.config(lang)

        if config['categories'].size > 0
          categories = config['categories']
        else 
          categories =  Octopress.site.categories.keys  
        end
        
        categories.each do |category|
          page = CategoryPage.new(Octopress.site, File.dirname(template.path), '.', File.basename(template.path))
          page.data.merge!({
            'category' => category,
            'layout' => config['layout'],
            'lang' => lang,
            'title' => config['title'] + category,
          })

          page.name = 'index.html'
          page.dir = category_dir(category, lang)

          page.process('index.html')

          categoryPages << page
        end
        categoryPages
      end

      def category_dir(category, lang=nil)
        lang = nil unless multilingual?
        category_base_dir = self.config(lang)['dir'].gsub(/^\/*(.*)\/*$/, '\1')
        File.join('/', lang || '', category_base_dir, slugifyCategory(category))
      end

      def multilingual?
        (defined?(Octopress::Multilingual) && !Octopress.site.config['lang'].nil?)
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
