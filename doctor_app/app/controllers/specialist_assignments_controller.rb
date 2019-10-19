class SpecialistAssignmentsController < ApplicationController
  def partial_list
    @specialist_assignments = SpecialistAssignment.where(institution_address_service_id: params[:institution_address_service_id])
    if @specialist_assignments.present?
      @institution = @specialist_assignments.first.institution
      @institution_address = @specialist_assignments.first.institution_address
    else
      institution_address_service = InstitutionAddressService.find(params[:institution_address_service_id])
      @institution = institution_address_service.institution
      @institution_address = institution_address_service.institution_address
    end
    render layout: false
  end
end
