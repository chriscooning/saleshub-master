class Errors::Dmc::NotFound < ::Errors::Base
  attr_accessor :entity_name, :id

  class << self
    def create(entity_name: entity_name, id: id)
      msg = "#{entity_name} with id: #{id} not found"
      self.new.tap do |exc|
        exc.entity_name = entity_name
        exc.id          = id
      end
    end
  end
end