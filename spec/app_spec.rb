# frozen_string_literal: true

require File.expand_path 'spec_helper.rb', __dir__
require 'factories/user'
require 'factories/post'
require 'factories/rating'

describe 'My Sinatra Application' do
  let(:ip1) { '192.168.23.23' }
  let(:ip2) { '127.0.0.1' }
  let(:user1) { create(:user, login: 'author1') }
  let(:user2) { create(:user, login: 'author2') }
  let(:post1) { create(:post, user_id: user1.id, ip: ip2, average_rate: 2.6) }
  let(:post2) { create(:post, user_id: user2.id, ip: ip2, average_rate: 4.1) }
  let(:post3) { create(:post, average_rate: 2.6) }

  before do
    create_list(:post, 2, user_id: user1.id, ip: ip1)
    create_list(:rating, 3, rate: 1, post_id: post1.id)
    create_list(:rating, 3, rate: 1, post_id: post3.id)
    create_list(:rating, 2, rate: 5, post_id: post1.id)
    create_list(:rating, 2, rate: 5, post_id: post3.id)
    create_list(:rating, 4, rate: 5, post_id: post2.id)
    create_list(:rating, 3, rate: 3, post_id: post2.id)
  end

  describe 'POST /api/v1/post' do
    let(:user) { create(:user, login: 'author') }
    let(:post_data) do
      { 'content' => 'Content', 'title' => 'Title' }
    end

    it 'creates new post' do
      post '/api/v1/post', { author: user.login, content: post_data['content'], title: post_data['title'] }.to_json,
           { 'Content-Type' => 'application/json' }

      expect(last_response).to be_ok
      expect(Post.last.content).to eq(post_data['content'])
      expect(Post.last.title).to eq(post_data['title'])
      expect(Post.last.user_id).to eq(user.id)
    end

    context "when there is no user with author's login" do
      it 'creates new user and post' do
        post '/api/v1/post', { author: 'new_author', content: post_data['content'], title: post_data['title'] }.to_json,
             { 'Content-Type' => 'application/json' }

        expect(last_response).to be_ok
        expect(User.last.login).to eq('new_author')
        expect(Post.last.user_id).to eq(User.last.id)
      end
    end

    it 'returns unprocessible entity if arguments are invalid' do
      post '/api/v1/post', { content: post_data['content'], title: post_data['title'] }.to_json,
           { 'Content-Type' => 'application/json' }

      expect(last_response.status).to eq(422)
    end
  end

  describe 'POST /api/v1/rate' do
    it 'updated average rate for post' do
      post '/api/v1/rate', { post_id: post1.id, rate: 3 }.to_json, { 'Content-Type' => 'application/json' }

      expect(JSON.parse(last_response.body)).to eq(2.7)
    end

    it 'does not raise an exception if arguments are invalid' do
      expect do
        post '/api/v1/ips', { rate: 'test' }.to_json,
             { 'Content-Type' => 'application/json' }
      end .not_to raise_error
    end
  end

  describe 'POST /api/v1/posts' do
    it 'returns appropriate posts' do
      post '/api/v1/posts', { count: 2, rate: 2.6 }.to_json, { 'Content-Type' => 'application/json' }

      expect(JSON.parse(last_response.body)).to eq([{ 'content' => post3.content, 'title' => post3.title },
                                                    { 'content' => post1.content, 'title' => post1.title }])
    end

    it 'does not raise an exception if arguments are invalid' do
      expect do
        post '/api/v1/ips', { count: 'test' }.to_json,
             { 'Content-Type' => 'application/json' }
      end .not_to raise_error
    end
  end

  describe 'POST /api/v1/ips' do
    it 'returns list of users with ip' do
      post '/api/v1/ips', { users: [user1.id, user2.id] }.to_json, { 'Content-Type' => 'application/json' }

      expect(JSON.parse(last_response.body)).to eq({ ip1 => [user1.id], ip2 => [user1.id, user2.id] })
    end

    it 'does not raise an exception if arguments are invalid' do
      expect { post '/api/v1/ips', { users: [] }.to_json, { 'Content-Type' => 'application/json' } }.not_to raise_error
    end
  end
end
