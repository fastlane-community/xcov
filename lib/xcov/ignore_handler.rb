
module Xcov
  class IgnoreHandler

    attr_accessor :list

    def initialize
      # We downcase ignored patterns in order to simulate a case-insensitive
      # comparison later
      @list = IgnoreHandler.read_ignore_file.map { |file| file.downcase }
    end

    def should_ignore_file filename
      return false if @list.empty?

      # perform case-insensitive comparisons
      downcased_filename = filename.downcase
      return true if @list.include?(downcased_filename)

      # Evaluate possible regexs
      return @list.any? { |pattern| downcased_filename =~ Regexp.new("#{pattern}$") }
    end

    def should_ignore_file_at_path path
      # Ignore specific files
      filename = File.basename(path)
      return true if should_ignore_file(filename)

      # Also ignore the files from ignored folders
      relative = relative_path(path).downcase
      return @list.any? { |ignored_path| relative.start_with? ignored_path }
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

    # Auxiliary methods

    # Returns a relative path against `source_directory`.
    def relative_path path
      require 'pathname'

      full_path = Pathname.new(path).realpath             # /full/path/to/project/where/is/file.extension
      base_path = Pathname.new(source_directory).realpath # /full/path/to/project/

      full_path.relative_path_from(base_path).to_s        # where/is/file.extension
    end

    def source_directory
      Xcov.config[:source_directory] || Dir.pwd
    end

  end
end
