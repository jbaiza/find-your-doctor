class InstitutionAddress < ApplicationRecord
  belongs_to :institution
  belongs_to :sub_region
  has_many :institution_address_services

  def sub_region_name
    sub_region&.name
  end
end
