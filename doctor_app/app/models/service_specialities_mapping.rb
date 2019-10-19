class ServiceSpecialitiesMapping < ApplicationRecord
  belongs_to :service
  belongs_to :speciality

  def self.load_data(file_name)
    require "CSV"
    CSV.foreach(file_name, col_sep: ",") do |row|
      next unless service = Service.find_by(name: row[1])
      next unless row[0].present?
      row[0].split(",").each do |s|
        next unless speciality = Speciality.find_by(code: s.upcase)
        ServiceSpecialitiesMapping.create(speciality: speciality, service: service)
      end
    end
  end

end
