class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :text
      t.references :task, foreign_key: true
      t.string :attachment

      t.timestamps
    end
  end
end
