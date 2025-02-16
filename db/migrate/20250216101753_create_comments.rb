class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :phone_number, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :likes_count
      t.integer :dislikes_count

      t.timestamps
    end
  end
end
