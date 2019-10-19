class InstitutionsController < ApplicationController

  # GET /institutions
  # GET /institutions.json
  # GET /institutions.csv
  def search
    @institution_address_services = InstitutionAddressService.where(service_id: params[:service_id]).includes(institution_address: [:institution])
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"insitutions.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

end
