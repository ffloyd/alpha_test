class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.references :loan, foreign_key: true
      t.integer :month
      t.boolean :deliquency

      t.timestamps
    end
  end
end
