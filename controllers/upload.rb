get '/upload' do 
  @pictures = Picture.all
  haml :upload
end

post '/upload' do
  @picture = Picture.create(:image => params[:image][:tempfile])
  haml :upload_post
end

get '/upload/delete' do
  pictures = Picture.all
  pictures.each do |p|
    GRID.delete(p.image_id)
    p.destroy
  end
  flash[:notice] = "Pictures removed"
  redirect '/'
end
