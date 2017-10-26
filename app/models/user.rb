class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable, :validatable
  include DeviseTokenAuth::Concerns::User
end
