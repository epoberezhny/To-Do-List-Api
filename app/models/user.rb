# frozen_string_literal: true

class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable

  include DeviseTokenAuth::Concerns::User
end
