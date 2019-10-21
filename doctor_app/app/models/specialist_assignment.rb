class SpecialistAssignment < ApplicationRecord
  belongs_to :specialist
  belongs_to :speciality
  belongs_to :institution_address_service

  def institution
    institution_address_service&.institution_address&.institution
  end

  def institution_address
    institution_address_service&.institution_address
  end

  def specialist_name
    specialist.name
  end

  def speciality_name
    speciality.name
  end

  def self.load_data(*file_names)
    require "CSV"
    @specialities = {}
    @institutions = {}
    file_names.each do |file_name|
      load_file_data(file_name)
    end
  end

  def self.load_file_data(file_name)
    CSV.foreach(file_name, col_sep: ",", headers: :first_row) do |row|
      name = row[6]
      specialist_identifier = row[10]
      unless specialist = Specialist.find_by(identifier: specialist_identifier)
        specialist = Specialist.create(identifier: specialist_identifier, name: name)
      end
      code = row[7].upcase
      speciality = @specialities[code] ||= Speciality.find_by(code: code)
      institution_code = row[4]
      institution = @institutions[institution_code] ||= Institution.find_by(code: institution_code)
      institution.institution_addresses.each do |institution_address|
        ServiceSpecialitiesMapping.where(speciality: speciality).map { |m| m.service }.each do |service|
          institution_address.institution_address_services.where(service: service).each do |ias|
            unless SpecialistAssignment.find_by(specialist: specialist, speciality: speciality, institution_address_service: ias)
              SpecialistAssignment.create(specialist: specialist, speciality: speciality, institution_address_service: ias)
            end
          end
        end
      end
    end
  end

end
