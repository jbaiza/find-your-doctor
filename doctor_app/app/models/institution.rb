class Institution < ApplicationRecord
  has_many :institution_addresses

  def self.load_data(file_name)
    require "CSV"
    CSV.foreach(file_name, col_sep: ",", headers: :first_row) do |row|
      if institution = Institution.find_by(code: row[4])
        institution.update(name: row[5])
      else
        Institution.create(code: row[4], name: row[5])
      end
    end
  end

end
