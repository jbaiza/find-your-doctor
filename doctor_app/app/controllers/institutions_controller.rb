class InstitutionsController < ApplicationController

  # GET /institutions
  # GET /institutions.json
  # GET /institutions.csv
  def search
    if service_id = params[:service_id]
      @institution_address_services = InstitutionAddressService.where(service_id: service_id).includes(institution_address: [:institution])
    elsif @search_term = params[:search_term]
      specialists = Specialist.where("LOWER(name) LIKE ? OR LOWER(comment) LIKE ?", "%#{@search_term.downcase}%", "%#{@search_term.downcase}%")
      specialities = Speciality.where("LOWER(name) LIKE ?", "%#{@search_term.downcase}%")
      services = Service.where("LOWER(name) LIKE ?", "%#{@search_term.downcase}%")
      # institutions = Institution.where("LOWER(name) LIKE ?", "%#{@search_term.downcase}%")
      institution_address_service_ids = []
      @institution_address_services = InstitutionAddressService.all
      criteria = false
      if specialists.present? or specialities.present?
        criteria = true
        specialist_assignments = SpecialistAssignment.all
        specialist_assignments = specialist_assignments.where(specialist: specialists) if specialists.present?
        specialist_assignments = specialist_assignments.where(speciality: specialities) if specialities.present?
        institution_address_service_ids.concat specialist_assignments.map { |sa| sa.institution_address_service_id }
        @institution_address_services = @institution_address_services.where(id: institution_address_service_ids)
      end
      if services.present?
        criteria = true
        @institution_address_services = @institution_address_services.where(service: services)
      end
      unless criteria
        @institution_address_services = @institution_address_services.where("1=0")
      end
    else
      @institution_address = InstitutionAddress.includes(:sub_region).all
    end
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"insitutions.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

end
