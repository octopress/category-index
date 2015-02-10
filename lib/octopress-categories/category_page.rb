# Copyright (c) 2010 Dave Perrett, http://recursive-design.com/
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
module Octopress
  module Categories
    class CategoryIndexPage < Jekyll::Page
      include Ink::Convertible

      # Initializes a new CategoryIndex.
      #
      #  +site+          is the Jekyll Site instance.
      #  +base+          is the String path to the <source>.
      #  +template+      is a Jekyll Layout object, containing the template.
      #  +category_dir+  is the String path between <source> and the category folder.
      #  +category+      is the category currently being processed.
      #  +config+        is the config
      def initialize(site, base, template, category_dir, category, config)
        @site  = site
        @base  = base
        @dir   = category_dir
        @name  = "index.html"

        process(@name)

        self.data = template.data.clone
        @content = template.content.clone

        self.data['category']    = category
        # Set the title for this page.
        title_prefix             = config['title_prefix'] || 'Category: '
        self.data['title']       = "#{title_prefix}#{category.capitalize}"

        # Set the meta-description for this page.
        meta_description_prefix  = config['meta_description_prefix'] || 'Category: '
        self.data['description'] = "#{meta_description_prefix}#{category.capitalize}"
      end
    end
  end
end
