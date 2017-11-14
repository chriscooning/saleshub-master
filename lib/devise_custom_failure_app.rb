class DeviseCustomFailureApp < Devise::FailureApp

  protected

  def i18n_message(default = nil)
    if warden_options[:attempted_path].eql?(root_path)
      nil
    else
      super
    end
  end
end
