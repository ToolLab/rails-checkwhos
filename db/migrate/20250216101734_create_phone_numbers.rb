class CreatePhoneNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :phone_numbers do |t|
      t.string :country_code
      t.string :country
      t.string :number

      t.timestamps
    end
  end
end
