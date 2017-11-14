class Services::Base
  attr_accessor :accessor

  def initialize(as: nil)
    @accessor = as
  end
end