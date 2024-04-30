# frozen_string_literal: true

class ChangeTasksCommentsCountDefault < ActiveRecord::Migration[5.1]
  change_column_default :tasks, :comments_count, from: nil, to: 0
end
