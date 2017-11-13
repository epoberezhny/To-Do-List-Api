class User < ActiveRecord::Base
  has_many :projects, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable

  include DeviseTokenAuth::Concerns::User
end
