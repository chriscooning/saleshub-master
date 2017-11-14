class Action
  module Types
    AND = :and
    OR  = :or
  end

  attr_accessor :resource_name, :names, :op_type

  class << self
    def or(resource_name, names)
      Action.new(resource_name, *names).tap do |action|
        action.op_type = Types::OR
      end
    end
  end

  def initialize(resource_name, *names)
    @resource_name = resource_name
    @names         = names
    @op_type       = Types::AND
  end

  def or?
    Types::OR == op_type
  end

  def and?
    Types::AND == op_type
  end
end