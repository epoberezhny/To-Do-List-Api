class User < ActiveRecord::Base
  has_many :projects, dependent: :destroy

  validates :username,
    presence:   true,
    uniqueness: true,
    length:     { in: 3..50 }
  validates :password,
    presence:     true,
    confirmation: true,
    format:       { with: /\A[[:alnum:]]+\z/ },
    length:       { is: 8 }

  devise :database_authenticatable, :registerable

  include DeviseTokenAuth::Concerns::User
end
