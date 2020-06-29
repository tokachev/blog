# frozen_string_literal: true

require 'faraday'
require 'json'

URL = 'http://0.0.0.0:4567/api/v1/'

(1..100).each do |user_id|
  (1..2000).each do |post_id|
    Faraday.post(URL + 'post',
                 { author: "user#{user_id}", title: "Title#{post_id}", content: "Content#{post_id}" }.to_json,
                 { 'Content-Type' => 'application/json', 'X-Forwarded-For' => "192.168.0.#{user_id / 2}" })
    puts "New post #{post_id} for #{user_id} created"
  end
end

(1..20_000).each do |post_id|
  (1..5).each do |rate|
    Faraday.post(URL + 'rate', { post_id: rate, rate: rate }.to_json, 'Content-Type' => 'application/json')
    puts "New rating for post #{post_id} created"
  end
end
