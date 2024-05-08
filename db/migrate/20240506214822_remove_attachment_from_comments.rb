# frozen_string_literal: true

class RemoveAttachmentFromComments < ActiveRecord::Migration[7.1]
  def change
    remove_column :comments, :attachment, :string
  end
end
