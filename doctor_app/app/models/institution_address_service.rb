class InstitutionAddressService < ApplicationRecord
  belongs_to :institution_address
  belongs_to :service

  def queue_size_display
    queue_size || case special_mark
    when 'R'
      I18n.t(:renovation)
    when 'P'
      I18n.t(:temporary_not_available)
    when 'N'
      I18n.t(:not_available)
    end
  end

  def self.load_data(branch_mapping_file, file_names)
    require "CSV"
    load_branch_mapping(branch_mapping_file)
    rows = []
    file_names.each do |category, file_name|
      next unless category = ServiceCategory.find_by(name: category)
      load_data_from_file(category, file_name)
    end
  end

  def self.load_branch_mapping(branch_mapping_file)
    @branch_mapping = {}
    CSV.foreach(branch_mapping_file, col_sep: ",", headers: :first_row) do |row|
      @branch_mapping[row[0].strip.downcase] = row[1]
    end
  end

  def self.institution_code_from_branch(branch_name)
    @branch_mapping[branch_name.downcase]
  end

  def self.load_data_from_file(category, file_name)
    csv = CSV.read(file_name, col_sep: ",", headers: :first_row)
    service_names = csv.headers[7..-1]
    missing = []
    csv.each do |row|
      branch_name = row[2].strip
      institution_code = institution_code_from_branch(branch_name)
      raise branch_name unless institution_code
      if institution = Institution.find_by(code: institution_code)
        region = Region.find_by(name: row[0])
        sub_region = SubRegion.find_by(region: region, name: row[1])
        address = row[3].strip
        info = row[4].strip
        lat = row[5]
        lon = row[6]
        if institution_address = InstitutionAddress.find_by(name: branch_name)
          institution_address.update(sub_region: sub_region, address: address, contact_info: info, lat: lat, lon: lon)
        else
          institution_address = InstitutionAddress.create(
            institution: institution, sub_region: sub_region, name: branch_name, address: address, contact_info: info, lat: lat, lon: lon
          )
        end
        load_services(category, institution_address, service_names, row)
      end
    end
  end

  def self.load_services(service_category, institution_address, service_names, row)
    row[7..-1].each_with_index do |value, index|
      if service = service_category.services.find_by(name: service_names[index])
        if value.to_i.to_s == value
          queue_size = value
          special_mark = nil
        elsif value.present?
          queue_size = nil
          special_mark = value
        end

        if institution_address_service = find_by(institution_address: institution_address, service: service)
          if value.present?
            institution_address_service.update(queue_size: queue_size, special_mark: special_mark)
          else
            institution_address_service.destroy
          end
        elsif value.present?
          create(institution_address: institution_address, service: service, queue_size: queue_size, special_mark: special_mark)
        end
      end
    end
  end

end
