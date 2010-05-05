require 'rubygems'
require 'sinatra'
require 'haml'
require 'rack-flash'
require 'custom_logger'

set :app_file, __FILE__
set :public, File.expand_path('public/')
set :views, File.expand_path('app/views/')

enable :sessions
use Rack::Flash

# ------- stylesheets ----------- #
get '/sass/:stylesheet' do 
  route = "../../public/sass/#{params[:stylesheet]}".to_sym
  content_type 'text/css', :charset => 'utf-8'
  sass route
end

# ------- site routes ----------- #
get '/' do
  haml :index
end

post '/' do
  page_name = params[:page_name].gsub(/ /, "-")
  page = File.open(File.expand_path('..') + "/views/#{page_name}.haml", "a")
  page << "\n#{params[:page_content]}"
  
  flash[:notice] = "page succesfully created"
  redirect "/"
end

# ------- page generator -------- #

get '/factory' do
  haml :factory
end

post '/factory' do
	if params[:page_name]
		page_name = params[:page_name].gsub(/ /, "-")
		page_content = params[:page_html]
		page = File.open("#{settings.views}/#{page_name}.erb", "w")
		page << page_content.to_s
		page.sync = true
	end
	flash[:notice] = "Page created"
	redirect "/factory"
end

# ------- Factory pages --------- #

get '/list' do
  @pages = []
  pages = Dir.open("#{settings.views}/factory").each do |page|
     unless page == "." || page == ".." || page == ".DS_Store" || page == "layout.erb"
      name = File.basename(page, '.erb')
     @pages << name
    end
  end
     
  haml :list
end

get '/factory/:page' do
  page = "/factory/#{params[:page]}".to_sym
  erb page, :layout => :"factory/layout"
end

# get '/:page' do
#   page = "#{params[:page]}".to_sym
#   if File.exists?("#{settings.views}/#{page}.haml")
#     haml page
#   else
#    erb page
#  end
# end




