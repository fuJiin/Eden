# Load Necessary Gems
require 'rubygems'
require 'sinatra'
require 'haml'
require 'rack-flash'
require 'mongo'
require 'mongo_mapper'
require 'joint'

def require_dir(dir_path)
  Dir[dir_path + '/*.rb'].each do |file|
    require File.join dir_path, File.basename(file, File.extname(file))
  end
end

def load_dir(dir_path)
  Dir[dir_path + '/*.rb'].each{|file| load file}
end

# Load Models and Libs
require_dir 'lib'
require_dir 'models'

# Load Configurations
require_dir 'config'
set :public, File.expand_path('public/')
set :views, File.expand_path('views/')

# Enable Flash Notices
enable :sessions
use Rack::Flash

# Load Controller and Routes
load_dir 'controllers'