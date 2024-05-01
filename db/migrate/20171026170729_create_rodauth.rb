# frozen_string_literal: true

class CreateRodauth < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'citext'

    create_table :users do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.integer :status, null: false, default: 1
      t.citext :email, null: false
      t.index :email, unique: true, where: 'status IN (1, 2)'
      t.string :password_hash
    end

    # Used by the active sessions feature
    create_table :user_active_session_keys, primary_key: %i[user_id session_id] do |t|
      t.references :user, foreign_key: true
      t.string :session_id
      t.datetime :created_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :last_use, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end

    # Used by the jwt refresh feature
    create_table :user_jwt_refresh_keys do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :user, foreign_key: true, null: false
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.index :user_id, name: 'user_jwt_rk_user_id_idx'
    end

    # Used by the password reset feature
    # create_table :user_password_reset_keys, id: false do |t|
    #   t.bigint :id, primary_key: true
    #   t.foreign_key :users, column: :id
    #   t.string :key, null: false
    #   t.datetime :deadline, null: false
    #   t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP" }
    # end

    # Used by the account verification feature
    # create_table :user_verification_keys, id: false do |t|
    #   t.bigint :id, primary_key: true
    #   t.foreign_key :users, column: :id
    #   t.string :key, null: false
    #   t.datetime :requested_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    #   t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP" }
    # end

    # Used by the verify login change feature
    # create_table :user_login_change_keys, id: false do |t|
    #   t.bigint :id, primary_key: true
    #   t.foreign_key :users, column: :id
    #   t.string :key, null: false
    #   t.string :login, null: false
    #   t.datetime :deadline, null: false
    # end
  end
end
