Cyrax::Repository.class_eval do

  private

  def pagination_params
    page = safe_integer(:page) || 1
    per_page = safe_integer(:per_page) || 10
    { page: page, per_page: per_page }
  end

  def safe_integer(name)
    param = params[name] && params[name].strip
    Integer(param) rescue nil
  end
end
