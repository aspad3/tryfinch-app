class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :customers, id: :uuid do |t|
      t.references :user, null: false
      t.text :access_token
      t.jsonb :meta_data
      t.jsonb :provider_data
      t.timestamps
    end
  end
end
