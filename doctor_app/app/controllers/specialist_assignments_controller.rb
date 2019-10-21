class SpecialistAssignmentsController < ApplicationController
  def partial_list
    if (institution_address_service_id = params[:institution_address_service_id]).present?
      @specialist_assignments = SpecialistAssignment.where(institution_address_service_id: params[:institution_address_service_id])
      if @specialist_assignments.present?
        @institution_address_service = @specialist_assignments.first.institution_address_service
      else
        @institution_address_service = InstitutionAddressService.find(params[:institution_address_service_id])
      end
    else
      @institution_address_services = InstitutionAddressService.where(institution_address_id: params[:institution_address_id])
      if (search_term = params[:search_term]).present?
        specialists = Specialist.where("LOWER(name) LIKE ? OR LOWER(comment) LIKE ?", "%#{search_term.downcase}%", "%#{search_term.downcase}%")
        specialities = Speciality.where("LOWER(name) LIKE ?", "%#{search_term.downcase}%")
        services = Service.where("LOWER(name) LIKE ?", "%#{search_term.downcase}%")
        institution_address_service_ids = []
        @specialist_assignments = SpecialistAssignment.all
        if specialists.present? or specialities.present?
          @specialist_assignments = SpecialistAssignment.where(institution_address_service: @institution_address_services)
          @specialist_assignments = @specialist_assignments.where(specialist: specialists) if specialists.present?
          @specialist_assignments = @specialist_assignments.where(speciality: specialities) if specialities.present?
          institution_address_service_ids.concat @specialist_assignments.map { |sa| sa.institution_address_service_id }
          @institution_address_services = @institution_address_services.where(id: institution_address_service_ids)
        end
        if services.present? && !(specialists.present? or specialities.present?)
          @institution_address_services = @institution_address_services.where(service: services)
          @specialist_assignments = @specialist_assignments.where(institution_address_service: @institution_address_services)
        end
        @institution_address_service = @institution_address_services.first
      end
    end
    @institution = @institution_address_service.institution
    @institution_address = @institution_address_service.institution_address
    render layout: false
  end
end
