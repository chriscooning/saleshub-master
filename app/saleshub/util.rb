module Util
  class << self
    def log_error(e)
      Rails.logger.error(pretty_print_exc(e))
    end

    private

    def pretty_print_exc(e)
      e.class.to_s + ": " + e.message + "\n" +
        e.backtrace.map { |it| "\s\s#{it}" }.join("\n")
    end
  end
end