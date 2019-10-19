class CreateInstitutionAddressServices < ActiveRecord::Migration[5.2]
  def change
    create_table :institution_address_services do |t|
      t.references :institution_address, foreign_key: true
      t.references :service, foreign_key: true
      t.integer :queue_size
      t.string :special_mark

      t.timestamps
    end
  end
end
