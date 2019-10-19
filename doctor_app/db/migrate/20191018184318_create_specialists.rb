class CreateSpecialists < ActiveRecord::Migration[5.2]
  def change
    create_table :specialists do |t|
      t.string :identifier
      t.string :name

      t.timestamps
    end
  end
end
