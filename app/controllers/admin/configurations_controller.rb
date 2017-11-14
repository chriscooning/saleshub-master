class Admin::ConfigurationsController < Admin::BaseController
  def edit
    authorize!(:access, Action.new(:configuration, :edit))
    @configuration = find_configuration
  end

  def update
    @configuration = find_configuration
    @configuration.update_attributes(configuration_params)

    flash[:notice] = 'Configuration sucessfully updated'
    redirect_to action: :edit
  end

  private

  def find_configuration
    ::Configuration.find_by_code('default')
  end

  def configuration_params
    params.require(:configuration).permit(options_attributes: [:id, :value])
  end
end
