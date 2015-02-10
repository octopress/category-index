# Categories

TODO: Write a gem description

[![Build Status](http://img.shields.io/travis/octopress/categories.svg)](https://travis-ci.org/octopress/categories)
[![Gem Version](http://img.shields.io/gem/v/octopress-categories.svg)](https://rubygems.org/gems/octopress-multilingual)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://octopress.mit-license.org)

## Installation

If you're using bundler add this gem to your site's Gemfile in the `:jekyll_plugins` group:

    group :jekyll_plugins do
      gem 'octopress-categories'
    end

Then install the gem with Bundler

    $ bundle

To install manually without bundler:

    $ gem install octopress-categories

Then add the gem to your Jekyll configuration.

    gems:
      - octopress-categories


## Usage

For multilingual category pages, install [octopress-multilingual](https://github.com/octopress/multilingual).

## Customize categories

To list detailed information about this plugin, run `$ octopress ink list categories`. This will output something like this:

```
Plugin: Octopress Categories - v0.0.1
Slug: categories
Category pages for Octopress and Jekyll pages.
================================================================================
 layouts:
  - category_feed.xml
  - category_index.html

 config:
   category_dir: "categories"
   prefixes: 
     title: "Category: "
     meta_description: "Category: "
   feed: 
     enabled: false
     count: 5
   permalinks:

 category-pages:
  - announcements                   /categories/announcements/

```

If you have posts written in English and German, and are using [octopress-multilingual](https://github.com/octopress/multilingual),
your permalinks will automatically be name-spaced by language, like this:

```
category-pages:
  - announcements-de                   /de/categories/announcements/
  - announcements-en                   /en/categories/announcements/
```

Octopress Ink can copy all of the plugin's assets to `_plugins/categories/*` where you can override them with your own modifications. This is
only necessary if you want to modify this plugin's behavior.

```
octopress ink copy categories
```

This will copy the plugin's configuration and layouts from the gem, to your local site. If, for example, you want to change the HTML for a category's index, you can simply edit the `_plugins/layouts/category_index.html` file.

If you want to revert to the defaults, simply delete any file you don't care to override from the `_plugins/categories/` directory.

## Configuration

To configure this plugin, first create a configuration file at `_plugins/categories/config.yml`. If you like, you can have Octopress Ink add it for you.

```
$ octopress ink copy categories --config-file
```

This will create a configuration file populated with the defaults for this plugin. Deleting this file will restore the default configuration.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/categories/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
