class CreateInstitutionAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :institution_addresses do |t|
      t.references :institution, foreign_key: true
      t.references :sub_region, foreign_key: true
      t.string :name
      t.string :address
      t.string :contact_info
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
