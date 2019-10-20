module ApplicationHelper

  def get_institution_address_service_csv_line(institution_address_service)
    institution_address = institution_address_service.institution_address
    CSV.generate_line(
      [institution_address.name, "#{institution_address.address}, #{institution_address.sub_region_name}",
        institution_address.contact_info, institution_address.lat, institution_address.lon,
        params[:service_id] ? institution_address_service.queue_size_or_text : nil, !@search_term.present? ? institution_address_service.id : nil, params[:search_term] || institution_address_service.id ? institution_address.id : nil, params[:service_id] ? institution_address_service.queue_size_display : nil
      ]
    ).html_safe
  end

  def get_institution_address_csv_line(institution_address)
    CSV.generate_line(
      [institution_address.name, "#{institution_address.address}, #{institution_address.sub_region_name}",
        institution_address.contact_info, institution_address.lat, institution_address.lon, nil, nil,
        params[:search_term] ? institution_address.id : nil, nil
      ]
    ).html_safe
  end

end
