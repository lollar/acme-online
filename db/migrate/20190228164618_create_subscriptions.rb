class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :due_on, null: false
      t.references :customer, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
