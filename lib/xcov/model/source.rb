require 'cgi'

module Xcov
  class Source < Xcov::Base

    attr_accessor :name
    attr_accessor :type
    attr_accessor :ignored
    attr_accessor :coverage
    attr_accessor :functions
    attr_accessor :function_templates

    def initialize (name, coverage, functions)
      @name = CGI::escapeHTML(name)
      @coverage = coverage
      @functions = functions
      @ignored = Xcov.ignore_list.include?(name)
      @displayable_coverage = self.create_displayable_coverage
      @coverage_color = self.create_coverage_color
      @id = Source.create_id(name)
      @type = Source.type(name)

      if @ignored
        Helper.log.info "Ignoring #{name} coverage".yellow
      end
    end

    def print_description
      puts "\t\t#{@name} (#{@coverage})"
      @functions.each do |function|
        function.print_description
      end
    end

    def html_value
      @function_templates = ""
      @functions.each do |function|
        @function_templates << function.html_value
      end

      Function.template("file").result(binding)
    end

    # Class methods

    def self.map (dictionary)
      name = dictionary["name"]
      coverage = dictionary["coverage"]
      functions = dictionary["functions"].map { |function| Function.map(function)}

      Source.new(name, coverage, functions)
    end

    def self.type (name)
      types_map = {
        ".swift" => "swift",
        ".m" => "objc",
        ".cpp" => "cpp",
        ".mm" => "cpp"
      }

      extension = File.extname(name)
      type = types_map[extension]
      type = "objc" if type.nil?

      type
    end

  end
end
