require "your_mechanic/version"

module YourMechanic
  class Schedule
    MINUTES = (0..1440).freeze

    def initialize
      @map = Array.new(MINUTES.last)
    end

    def add(from, to)
      set(from, to, 1)
    end

    def remove(from, to)
      set(from, to, nil)
    end

    def available_intervals
      from = nil

      MINUTES.each_with_object([]) do |idx, res|
        if @map[idx]
          from ||= idx
          next
        elsif from
          res.push([from, idx])
          from = nil
        end
      end
    end

    private

    def set(from, to, value)
      raise RuntimeError unless from < to && MINUTES.cover?(from) && MINUTES.cover?(to)

      (from...to).each { |idx| @map[idx] = value }
    end
  end
end
