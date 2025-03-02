class CreateArchivePayrolls < ActiveRecord::Migration[7.1]
  def change
    create_table :archive_payrolls do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :file_path
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
