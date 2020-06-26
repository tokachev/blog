# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :post

  validates :login, presence: true
end
