class Region < ApplicationRecord

  def self.load_data(*file_names)
    require "CSV"
    @regions = {}
    file_names.each do |file_name|
      load_data_from_file(file_name)
    end
    save_regions
  end

  def self.load_data_from_file(file_name)
    CSV.foreach(file_name, col_sep: ",", headers: :first_row) do |row|
      region = @regions[row[0]] ||= {}
      region[row[1]] = 1
    end
  end

  def self.save_regions
    @regions.each do |region_name, sub_regions|
      unless region = Region.find_by(name: region_name)
        region = Region.create(name: region_name)
      end
      sub_regions.each do |sub_region_name, _|
        unless SubRegion.find_by(region: region, name: sub_region_name)
          SubRegion.create(region: region, name: sub_region_name)
        end
      end
    end
  end

end
