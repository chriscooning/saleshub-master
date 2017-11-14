class Services::AccessTables
  class << self
    def template
      AccessTableTemplate.first
    end
  end

  def set_permissions(user, permissions)
    access_table = user.access_table
    new_permissions_hash = {}
    permissions.uniq.each do |perm_key|
      resource_name, action_name = perm_key.split(':').map(&:to_sym)
      new_permissions_hash[resource_name] ||= []
      new_permissions_hash[resource_name] << action_name
    end
    access_table.permissions = new_permissions_hash
    access_table.save
  end
end