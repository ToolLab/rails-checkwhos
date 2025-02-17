class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.references :phone_number, null: false, foreign_key: true
      t.string :ip, null: false
      t.string :referrer
      t.datetime :viewed_at, null: false

      t.timestamps

      # 성능을 위한 인덱스 추가
      t.index [ :phone_number_id, :viewed_at ]
      t.index [ :ip, :viewed_at ]
      t.index :viewed_at
    end
  end
end
