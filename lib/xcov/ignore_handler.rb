
module Xcov
  class IgnoreHandler

    attr_accessor :list

    def initialize
      @list = IgnoreHandler.read_ignore_file
    end

    def should_ignore_file filename
      return false if @list.empty?
      return true if @list.include?(filename)

      # Evaluate possible regexs
      return @list.any? { |pattern| filename =~ Regexp.new("#{pattern}$") }
    end

    # Static methods

    def self.read_ignore_file
      require "yaml"
      ignore_file_path = Xcov.config[:ignore_file_path]
      ignore_list = []
      begin
        ignore_list = YAML.load_file(ignore_file_path)
      rescue
        UI.message "Skipping file blacklisting as no ignore file was found at path #{ignore_file_path}".yellow
      end

      return ignore_list
    end

  end
end
