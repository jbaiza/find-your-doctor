class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :service_category, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
