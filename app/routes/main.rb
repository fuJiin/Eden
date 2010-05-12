require 'rubygems'
require 'sinatra'
require 'haml'
require 'rack-flash'
require 'mongo'
require 'mongo_mapper'
require 'custom_logger'
require 'uri'

# mapping database #
# if ENV['MONGOHQ_URL']
#   MongoMapper.config = {RACK_ENV => {'uri' => ENV['MONGOHQ_URL']}}
# else
#   MongoMapper.config = {RACK_ENV => {'uri' => 'mongodb://localhost/sushi'}}
# end

uri = URI.parse(ENV['MONGOHQ_URL'])
conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
db = conn.db(uri.path.gsub(/^\//, ''))
MongoMapper.database = db
# ---------------- #

class Page
  include MongoMapper::Document
  key :content, String
  key :name, String
end

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
	  page = Page.create(:name => params[:page_name], :content => params[:page_html])
  	flash[:notice] = "Page created"
  end
	redirect "/factory"
end

# ------- Factory pages --------- #

get '/list' do
  @pages = Page.all
  haml :list
end

get '/factory/:page' do
  page = Page.find(:name => params[:name])
  @content = page.content
  haml :page
end
