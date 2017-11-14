class Services::Geo < ::Services::Base
  US_STATE_CODES = ::State::CODES.keys
  US_STATES_INVERTED = ::State::CODES.invert

  class << self
    def us_state_codes
      US_STATE_CODES
    end

    def us_states
      ::State::CODES
    end

    def us_states_inverted
      US_STATES_INVERTED
    end
  end
end