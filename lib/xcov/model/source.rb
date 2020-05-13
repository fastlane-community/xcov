require 'cgi'

module Xcov
  class Source < Xcov::Base

    attr_accessor :name
    attr_accessor :location
    attr_accessor :type
    attr_accessor :ignored
    attr_accessor :coverage
    attr_accessor :functions
    attr_accessor :function_templates
    attr_accessor :lines

    def initialize(name, location, coverage, functions, lines = nil)
      @name = CGI::escapeHTML(name)
      @location = CGI::escapeHTML(location)
      @coverage = coverage
      @functions = functions
      @ignored = Xcov.ignore_handler.should_ignore_file_at_path(location)
      @displayable_coverage = self.create_displayable_coverage
      @coverage_color = self.create_coverage_color
      @id = Source.create_id(name)
      @type = Source.type(name)
      @lines = lines

      if @ignored
        UI.message "Ignoring #{name} coverage".yellow
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

    def markdown_value
      "#{@name} | `#{@displayable_coverage}` | #{coverage_emoji}\n"
    end

    def json_value
      value = {
        "name" => @name,
        "coverage" => @coverage,
        "type" => @type,
        "functions" => @functions ? @functions.map{ |function| function.json_value } : []
      }
      if @ignored then
        value["ignored"] = true
      end
      return value
    end

    # Class methods

    def self.map(dictionary)
      name = dictionary["name"]
      location = dictionary["location"]
      coverage = dictionary["coverage"]
      functions = dictionary["functions"].map { |function| Function.map(function)}
      lines = map_lines(dictionary["lines"])
      Source.new(name, location, coverage, functions, lines)
    end

    def self.map_lines(dictionaries)
      return nil if dictionaries.nil?
      dictionaries.map { |line| Line.map(line) }
    end

    def self.type(name)
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
