class AddCustomerIdToUsers < ActiveRecord::Migration
  def up
    add_column :users, :customer_id, :string, default: nil
    add_index :users, :customer_id
  end

  def down
    remove_column :users, :customer_id
    remove_index :users, :customer_id
  end
end
