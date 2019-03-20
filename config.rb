#Bootstrap is used to style bits of the demo. Remove it from the config, gemfile and stylesheets to stop using bootstrap
require 'html_truncator'
require 'redcarpet'
require "sanitize"
require 'middleman-inliner'
require 'nokogiri'
redirect 'index.html', to: '/fr/index.html'


# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

# Use '#id' and '.classname' as div shortcuts in slim
activate :protect_emails

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

set(:port, 3636)


set :url_root, 'https://www.colloquevecteur.com'

set :index_file, "index.html"
set :markdown_engine, :redcarpet
set :relative_links, true
set :fonts_dir, 'fonts'
set :js_dir, 'javascripts'
set :index_file, "index.html"


activate :dato, preview: true, live_reload: true, token: '045f8415a95f4ed3d3be0898d8509f'
activate :directory_indexes
activate :search_engine_sitemap, exclude_attr: 'hidden'
activate :inliner
activate :sprockets
activate :i18n, langs: [:fr, :en], :mount_at_root => :fr


configure :development do
  activate :livereload
end


activate :robots,
  :rules => [
    {:user_agent => '*', :allow => %w(/)}
  ],
  :sitemap => "https://www..com/sitemap.xml"

activate :google_analytics do |ga|
    ga.tracking_id = 'UA-129577045-1' # Replace with your property ID.
end
# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page "/templates/*", :layout => "layout"
page '/sitemap.xml', :layout => false

proxy "_redirects", "netlify-redirects", ignore: true
proxy "_headers", "netlify-headers", ignore: true

dato.tap do |dato|
  dato.available_locales.each do |locale|
    I18n.with_locale(locale) do
    # iterate over the "Blog post" records...

    dato.publications.each do |publication|
    if publication.actif
    if publication.section.page_unique
      proxy(
        "/#{locale}/#{publication.section.slug}/index.html",
        "/templates/blog_detail.html",
        locals: { publication: publication },
        locale: locale
      )
    else
    # ...and create a page for each service starting from a template!
        proxy(
          "/#{locale}/#{publication.section.slug}/#{publication.slug}/index.html",
          "/templates/blog_detail.html",
          locals: { publication: publication },
          locale: locale
        )
      end
      end
     end
     end
     end
end

  dato.tap do |dato|
    dato.available_locales.each do |locale|
      I18n.with_locale(locale) do
      # iterate over the "Blog post" records...

      dato.publications.each do |publication|
      if publication.actif


      # ...and create a page for each service starting from a template!
          proxy(
            "/#{locale}/#{publication.section.slug}/index.html",
            "/templates/blog_detail.html",
            locals: { publication: publication },
            locale: locale
          )
        end
       end
       end
       end
       end

       dato.tap do |dato|
         dato.available_locales.each do |locale|
           I18n.with_locale(locale) do
           # iterate over the "Blog post" records...

           dato.conferenciers.each do |item|
           if item.actif


           # ...and create a page for each service starting from a template!
               proxy(
                 "/#{locale}/#{item.slug}/index.html",
                 "/templates/simple.html",
                 locals: { item: item },
                 locale: locale
               )
             end
            end
            end
            end
            end


dato.tap do |dato|
  dato.available_locales.each do |locale|
    I18n.with_locale(locale) do
    # iterate over the "Blog post" records...
    dato.sections.each do |section|
    if section.actif
    if section.accueil
    dato.publications.each do |publication|
    if publication.actif
    publication.section == section

    # ...and create a page for each service starting from a template!
        proxy(
          "/#{locale}/index.html",
          "/templates/index.html",
          locals: { section: section, publication: publication },
          locale: locale
        )
      end
     end
     end
     end
     end
     end
    end
  end





# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy product.yml files to product.html

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# pretty urls

ignore '/templates/*'

helpers do


  def strip_tags(html)
    Sanitize.clean(html.strip).strip
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    Redcarpet::Markdown.new(renderer).render(text)
  end

end
# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css, inline: true
  activate :minify_javascript
  activate :minify_html
  activate :relative_assets
  activate :asset_hash, :ignore => [%r{#fonts/.*}, %r{#stylesheets/fonts/.*}]
  activate :gzip
  activate :automatic_image_sizes
  activate :automatic_alt_tags
end
