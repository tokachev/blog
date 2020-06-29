# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: 'Post' do
    sequence(:content) { |n| "Content #{n}" }
    sequence(:title) { |n| "Title #{n}" }
  end

  # content "Content"
  # title "Title"
end
