disable :layout

activate :automatic_image_sizes

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :cache_buster
  activate :relative_assets
  activate :smusher
end
