# Routing for Sass Files
get %r{/stylesheets/(.+).css} do 
  content_type 'text/css', :charset => 'utf-8'
  sass :"../public/sass/#{params[:captures].first}"
end

# Routing for Picture files
get '/picture/:id' do
  content_type 'image/jpeg'
  @picture = Picture.find(params[:id])
  @image = GRID.get(@picture.image_id)
  @image.read
end