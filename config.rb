require 'maruku'
require 'makepdf'

# Reload the browser automatically whenever files change
activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  def markdown(str)
    Maruku.new(str).to_html
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
    [s, e].reject { |ele| ele.nil? }.map do |elem|
      begin
        elem = Date.parse(elem) unless Date === elem
        "<time datetime='#{elem}'>#{elem.strftime("%b %Y")}</time>"
      rescue ArgumentError # elem is 'present'
        "<time datetime='#{DateTime.now}}'>#{elem}</time>"
      end
    end.join(' - ')
  end

  def method_missing(sym)
    data.resume.send(sym) || super
  end

  def cols_to_rows(data)
    header, *rows = data
    header.zip(*rows)
  end

  def headers(data)
    cols_to_rows(data)[0]
  end

  def rows(data)
    cols_to_rows(data)[1..-1]
  end

  def parse_to_arr(data)
    data.map do |x|
      x.split(', ')
    end
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

  activate :pdfmaker
end
