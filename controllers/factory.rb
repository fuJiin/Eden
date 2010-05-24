# Factory Related Routes

get '/factory' do
  @pictures = Picture.all
  haml :factory
end

post '/factory' do
  if params[:page_name] && !params[:page_name].empty?
    page = Page.create(:name => params[:page_name], :content => params[:page_html])
    flash[:notice] = "Page created"
  else
    flash[:notice] = "Error page not created"
  end
  redirect "/factory"
end

get '/factory/:page' do
  page = Page.first(:name => params[:page].gsub(/ /,"_"))
  @content = page.content
  haml :page
end

get '/factory/:page/delete' do
  page = Page.first(:name => params[:page].gsub(/ /,"_"))
  if page.destroy
    flash[:notice] = 'Page removed'
    redirect "/list"
  end
end

get '/list' do
  @pages = Page.all
  haml :list
end
