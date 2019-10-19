class CreateServiceSpecialitiesMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :service_specialities_mappings do |t|
      t.references :service, foreign_key: true
      t.references :speciality, foreign_key: true

      t.timestamps
    end
  end
end
