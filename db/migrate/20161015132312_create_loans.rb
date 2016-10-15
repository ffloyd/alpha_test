class CreateLoans < ActiveRecord::Migration[5.0]
  def change
    create_table :loans do |t|
      t.string :legal_entity
      t.decimal :amount
      t.integer :duration
      t.integer :period
      t.decimal :annual_rate
      t.decimal :deliquency_rate

      t.timestamps
    end
  end
end
