# frozen_string_literal: true

class Rating < ActiveRecord::Base
  belongs_to :post

  validates :rate, presence: true
end
