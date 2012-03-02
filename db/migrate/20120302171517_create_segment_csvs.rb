class CreateSegmentCsvs < ActiveRecord::Migration
  def change
    create_table :segment_csvs do |t|
      t.text :csv
      t.string :filename
      t.integer :session_id
      t.text :input_csv
      t.float :epsilon

      t.timestamps
    end
  end
end
