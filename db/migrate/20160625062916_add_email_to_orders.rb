class AddEmailToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :email, :string
  end
end
