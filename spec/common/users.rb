require "spec_helper"

def admin_user
  Services::Users.new.create(
    first_name: 'Super',
    last_name: 'Admin',
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
  ).tap do |u|
    u.role = User::Roles::ADMIN
    u.save!
  end
end

def emil_user
  Services::Users.new.create(
    first_name: 'Emil',
    last_name: 'Svendsen',
    email: 'emil@example.com',
    password: 'password',
    password_confirmation: 'password'
  ).tap do |u|
    raise 'Emil is invalid' if !u.valid?
  end
end