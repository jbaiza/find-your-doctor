class Service < ApplicationRecord
  belongs_to :service_category

  def self.load_data(file_names)
    require "CSV"
    @services = {}
    file_names.each do |category, file_name|
      @services[category] = load_data_from_file(file_name)
    end
    save_services
  end

  def self.load_data_from_file(file_name)
    CSV.read(file_name, col_sep: ",", headers: :first_row).headers[7..-1]
  end

  def self.save_services
    @services.each do |category_name, services|
      unless category = ServiceCategory.find_by(name: category_name)
        category = ServiceCategory.create(name: category_name)
      end
      services.each do |service_name|
        unless Service.find_by(service_category: category, name: service_name)
          Service.create(service_category: category, name: service_name)
        end
      end
    end
  end

end
