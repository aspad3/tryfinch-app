class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.integer :user_id
      t.text :access_token
      t.jsonb :response_finch
      t.timestamps
    end

    add_index :customers, :user_id
  end
end
