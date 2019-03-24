# server.rb
require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

# DB Config
Mongoid.load! "mongoid.config"

# Models
class FileControl
  include Mongoid::Document

  attr_accessor :name, :tags

  def initialize(file)
    @name = name
    @tags = tags
  end

  def create

  end

end

# Endpoints
namespace '/api/v1' do
  # search for files
  get '/files/tag_search_query/page' do
  end

  # create new file
  post '/file' do
  end

end
