# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.index %i[user_id name], unique: true

      t.timestamps
    end
  end
end
