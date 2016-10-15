class AddPayAllToPayments < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :pay_all, :boolean
  end
end
