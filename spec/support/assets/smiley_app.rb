require 'sinatra'

set :app_file, __FILE__

set :root, File.expand_path(File.dirname(__FILE__))
set :static, true

get '/' do
  erb :smiley_site
end

get '/root' do
  'root is ' + settings.root
end

get '/public' do
  'root is ' + settings.public_directory
end  