# frozen_string_literal: true

class AddAttachmentDataToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :attachment_data, :jsonb
  end
end
