require 'erb'

module Xcov
  class Base

    attr_accessor :name
    attr_accessor :coverage
    attr_accessor :displayable_coverage
    attr_accessor :coverage_color

    attr_accessor :id

    def create_displayable_coverage
      return "-" if @ignored

      "%.2f%%" % [(@coverage*100)]
    end

    def create_coverage_color
      return "#363636" if @ignored

      if @coverage > 0.8
        return "#1FCB32"
      elsif @coverage > 0.65
        return "#FCFF00"
      elsif @coverage > 0.5
        return "#FF9C00"
      else
        return "#FF0000"
      end
    end

    def create_summary
      if @coverage > 0.8
        return "Overall coverage is good"
      elsif @coverage > 0.65
        return "There is room for improvement"
      elsif @coverage > 0.5
        return "Almost unmaintainable"
      else
        return "Keep calm and leave the boat"
      end
    end

    def coverage_emoji
      return "" if @ignored

      if @coverage >= 0.80
        return ":white_check_mark:"
      elsif @coverage >= 0.50
        return ":warning:"
      elsif @coverage >= 0.25
        return ":no_entry_sign:"
      else
        return ":skull:"
      end
    end

    # Class methods
    def self.template(name)
      ERB.new(File.read(File.join(File.dirname(__FILE__), "../../../views/", "#{name}.erb")))
    end

    def self.create_id(name)
      char_map = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      random = (0...50).map { char_map[rand(char_map.length)] }.join
      pre_hash = "#{random}_#{name}"
      Digest::SHA1.hexdigest(pre_hash)
    end

  end
end
