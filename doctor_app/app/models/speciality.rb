class Speciality < ApplicationRecord

  def self.load_data(*file_names)
    file_names.each do |file_name|
      load_file_data(file_name)
    end
  end

  def self.load_file_data(file_name)
    CSV.foreach(file_name, col_sep: ",", headers: :first_row) do |row|
      code = row[7].strip.upcase
      name = row[8]
      unless Speciality.find_by(code: code)
        Speciality.create(code: code, name: name)
      end
    end
  end

end
