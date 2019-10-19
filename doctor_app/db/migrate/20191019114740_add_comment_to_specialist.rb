class AddCommentToSpecialist < ActiveRecord::Migration[5.2]
  def change
    add_column :specialists, :comment, :text
  end
end
