class CreateArchivePayrolls < ActiveRecord::Migration[7.1]
  def change
    create_table :archive_payrolls do |t|
      t.uuid :customer_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :archive_payrolls, :customer_id
  end
end
