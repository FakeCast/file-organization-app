# server.rb
require 'sinatra'
require 'sinatra/namespace'
require 'mongoid'

APP_ROOT = File.dirname(__FILE__)
# DB Config
Mongoid.load! File.join(APP_ROOT, 'mongoid.config')

# Number of items per page
PAGE_SIZE = 10

# Models
class FileControl
  include Mongoid::Document

  field :name, type: String
  field :tags, type: Array

  validates :name, presence: true
  validates :tags, presence: true
end

# Serializer
class Serializer
  def initialize(params = {})
    @data = params[:data]
    @tags = params[:tags]
  end

  def related_tags
    @tags = @data.distinct(:tags) - @tags
    @tags.map! { |tag| { tag: tag, count: @data.where(tags: tag).count } }
  end

  def records
    @data.map! { |file| { uuid: file._id.to_s, name: file.name } }
  end

  def as_json
    {
      total_records: @data.count,
      related_tags: related_tags,
      records: records
    }.to_json
  end
end

# Helpers
module AppHelpers
  def remove_filter_character(tags)
    tags.map! { |tag| tag.delete! '+-' }
  end

  def tag_filter(tags)
    tags = tags.split(/(?=[+-])/)
    permit = tags.select { |tag| tag.include? '+' }
    denny = tags.select { |tag| tag.include? '-' }
    {
      permitted_tags: remove_filter_character(permit),
      denied_tags: remove_filter_character(denny)
    }
  end

  def invalid_tag?(data)
    data['tags'].any? { |tag| tag.match(/[\s+-]/) }
  end

  def json_params
    data = JSON.parse(request.body.read)
    if invalid_tag?(data)
      halt 400, { message: 'Request may not include +, - and whitespaces' }
        .to_json
    else
      data
    end
  rescue
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end
Sinatra::Application.helpers AppHelpers

# Endpoints
namespace '/api/v1' do
  before do
    content_type 'application/json'
  end


  # search for files
  get '/files/:tags/:page' do
    result = FileControl
             .all(tags: tag_filter(params[:tags])[:permitted_tags])
             .nin(tags: tag_filter(params[:tags])[:denied_tags])
             .skip(PAGE_SIZE * (params[:page].to_i - 1)).limit(PAGE_SIZE)
    Serializer
      .new(data: result, tags: tag_filter(params[:tags])[:permitted_tags])
      .as_json
  end

  # create new file
  post '/file' do
    file = FileControl.create(json_params)
    if file.save
      status 200
      { uuid: file.id.to_s }.to_json
    else
      status 422
      FileControl.new(file).to_json
    end
  end
end
