class CreateSpecialistAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :specialist_assignments do |t|
      t.references :specialist, foreign_key: true
      t.references :speciality, foreign_key: true
      t.references :institution_address_service, foreign_key: true

      t.timestamps
    end
  end
end
