class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address, null: false
      t.string :zip_code, null: false
      t.string :card_token

      t.timestamps
    end
  end
end
