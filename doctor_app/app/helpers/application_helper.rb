module ApplicationHelper

  def get_institution_address_service_csv_line(institution_address_service)
    institution_address = institution_address_service.institution_address
    CSV.generate_line(
      [institution_address.name, "#{institution_address.address}, #{institution_address.sub_region_name}",
        institution_address.contact_info, institution_address.lat, institution_address.lon,
        institution_address_service.queue_size_display, institution_address.id
      ]
    ).html_safe
  end

end
