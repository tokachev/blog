# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/param'
require 'json'
require_relative 'models/post'
require_relative 'models/user'
require_relative 'models/rating'

helpers Sinatra::Param

set :show_exceptions, false
set :raise_sinatra_param_exceptions, true
set :server, :puma

error Sinatra::Param::InvalidParameterError do
  status 422
  { error: "#{env['sinatra.error'].param} is invalid" }.to_json
end

before do
  content_type :json
  begin
    @params = JSON.parse(request.body.read)
  rescue StandardError
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end

namespace '/api/v1' do
  post '/post' do
    param :author, String, required: true
    param :content, String, required: true
    param :title, String, required: true

    user = User.find_or_create_by(login: params['author'])
    post = Post.new(user: user, content: params['content'], title: params['title'], ip: request.ip)

    if post.save
      status 200
    else
      status 422
    end
  end

  post '/rate' do
    param :post_id, Integer, required: true
    param :rate, Integer, in: [1, 2, 3, 4, 5], required: true

    post = Post.find(params['post_id'])

    ActiveRecord::Base.transaction do
      Rating.create(post: post, rate: params['rate'])
      average = post.ratings.average(:rate).round(1)
      post.update(average_rate: average)
    end

    post.average_rate.to_json
  end

  post '/posts' do
    param :count, Integer, required: true
    param :rate, Float, required: true

    count = params['count']
    rate = params['rate']
    Post.select(:title, :content).where(average_rate: rate).order(id: :desc).limit(count).as_json(except: :id).to_json
  end

  post '/ips' do
    param :users, Array, required: true

    posts = Post.where(user_id: params['users']).pluck(:ip, :user_id).uniq

    Hash[posts.group_by(&:first).map { |k, a| [k, a.map(&:last)] }].to_json
  end
end
