module Ransack
  module Nodes
    class Value < Node
      def cast_to_time(val)
        if val.is_a?(Array)
          Time.zone.local(*val) rescue nil
        else
          unless val.acts_like?(:time)
            val = if val.is_a?(String)
              parse_str_to_time(val) rescue Time.zone.parse(val) rescue nil
            else
              val.to_time rescue val
            end
          end
          val.in_time_zone rescue nil
        end
      end

      private

      def parse_str_to_time(str)
        now = Time.now
        parts = Date._strptime(str, '%m/%d/%Y')
        return if parts.empty?

        time = Time.new(
          parts.fetch(:year, now.year),
          parts.fetch(:mon, now.month),
          parts.fetch(:mday, now.day),
          parts.fetch(:hour, 0),
          parts.fetch(:min, 0),
          parts.fetch(:sec, 0) + parts.fetch(:sec_fraction, 0),
          parts.fetch(:offset, 0)
        )

        if parts[:offset]
          ActiveSupport::TimeWithZone.new(time.utc, Time.zone)
        else
          ActiveSupport::TimeWithZone.new(nil, Time.zone, time)
        end
      end
    end
  end
end
