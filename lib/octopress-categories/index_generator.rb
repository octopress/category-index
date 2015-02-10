require 'octopress-ink'
require 'octopress-categories/category_page'

class GenerateCategoryIndexes < Jekyll::Generator
      priority :low
      safe true

      def generate(site)
        config = Ink.configuration["categories"]
        template = site.layouts["categories:category_index"]
        category_base_dir = config['category_dir']

        category_pages = []

        if defined? Octopress::Multilingual
          site.languages.each do |lang|
            category_base_dir = File.join(lang, category_base_dir)
            category_pages_lang = createCategoryPages(site, template, config, category_base_dir)
            category_pages_lang.each { |p|
              p.data['lang'] = lang
            }
            #category_pages.concat(category_pages_lang)
          end
        else
          category_pages = createCategoryPages(site, template, config, category_base_dir)
        end

        site.pages.concat(category_pages)
      end

      def createCategoryPages(site, template, config, category_base_dir)
        categoryPages = []
        site.categories.keys.each do |category|
          category_dir = category_dir(category_base_dir, category)
          categoryPages << CategoryPage.new(site, site.source, template, category_dir, category, config)
        end
        categoryPages
      end
      def category_dir(base_dir, category)
        base_dir = (base_dir || CATEGORY_DIR).gsub(/^\/*(.*)\/*$/, '\1')
        category = category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').tr( '^A-Za-z0-9\-_', '-' ).downcase
        File.join(base_dir, category)
      end

    end