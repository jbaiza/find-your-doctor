class CreateSubRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_regions do |t|
      t.references :region, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
