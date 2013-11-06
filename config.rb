require 'maruku'

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  def markdown(str)
    Maruku.new(str).to_html
  end

  def md_link(anchor, link)
    markdown "[#{anchor}](#{link})"
  end

  def filter_hide(ary)
    ary.reject do |elem|
      case elem
      when String
        elem.slice("hide")
      else
        elem["hide"]
      end
    end
  end

  def period(s, e = nil)
    [s, e].reject { s.nil? }.map do |elem|
      begin
        elem = Date.parse(elem) unless Date === elem
        "<time datetime='#{elem}'>#{elem.strftime("%b %Y")}</time>"
      rescue ArgumentError # elem is 'present'
        "<time datetime='#{DateTime.now}}'>Present</time>"
      end
    end.join(' - ')
  end

  def method_missing(sym)
    data.resume.send(sym) || super
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

activate :deploy do |deploy|
  deploy.method = :git
end
