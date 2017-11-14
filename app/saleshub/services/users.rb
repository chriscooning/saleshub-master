class Services::Users < ::Services::Base
  def build
    User.new.tap {|u| u.role = Role.find_by_code('user') }
  end

  def create(attributes, permissions = {})
    User.new(attributes).tap do |u|
      u.role_id ||= Role.find_by_code('user').id
      u.save

      if u.valid?
        if u.is_admin?
          access_table = u.build_access_table(permissions: {})
          u.activate
        elsif u.is_user?
          access_table = u.build_access_table(permissions: permissions)
        else
          access_table = u.build_access_table(permissions: {})
        end
        access_table.save

        UserMailer.account_created(attributes[:email], attributes[:password]).deliver
      end
    end
  end

  def update(user, attributes)
    user.tap do |u|
      u.update_attributes(attributes)
    end
  end
end
