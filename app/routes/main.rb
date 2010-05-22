require 'rubygems'
require 'sinatra'
require 'haml'
require 'rack-flash'
require 'mongo'
require 'mongo_mapper'
require 'custom_logger'
require 'uri'
require 'joint'

# require 'rack/gridfs'

# mapping database #
case ENV['RACK_ENV']
when "production"
  conf = {:db => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.config = conf
  MongoMapper.connect(:db)
when "development"
  MongoMapper.database = "mydb"
end

GRID = Mongo::Grid.new(MongoMapper.database)
#---------------- #

class Page
  include MongoMapper::Document
  key :content, String
  key :name, String

  validates_uniqueness_of :name
  validates_presence_of :name
  
  many :pictures
end

class Picture
  include MongoMapper::Document
  plugin Joint
  
  attachment :image
  
  def show
    return GRID.get(self.image_id).read
  end
end

# ------------------- #

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

# ------- page generator -------- #

get '/factory' do
  @pictures = Picture.all
  haml :factory
end

post '/factory' do
  if params[:page_name] && !params[:page_name].empty?
    page = Page.create(:name => params[:page_name].gsub(/ /,"_"), :content => params[:page_html])
    flash[:notice] = "Page created"
  else
    flash[:notice] = "Error page not created"
  end
  redirect "/factory"
end

# ------- Factory pages --------- #

get '/list' do
  @pages = Page.all
  haml :list
end

get '/factory/:page/delete' do
  page = Page.first(:name => params[:page].gsub(/ /,"_"))
  if page.destroy
    flash[:notice] = 'Page removed'
    redirect "/list"
  end
end

get '/factory/:page' do
  page = Page.first(:name => params[:page].gsub(/ /,"_"))
  @content = page.content
  haml :page
end

get '/upload' do 
  @pictures = Picture.all
  haml :upload
end

post '/upload' do
  # @image = Image.create(params[:picture])
  @picture = Picture.create(:image => params[:image][:tempfile])
  # @picture.file = params[:picture]
  # @picture.save
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

get '/picture/:id' do
  content_type 'image/jpeg'
  @picture = Picture.find(params[:id])
  @image = GRID.get(@picture.image_id)
  @image.read
end