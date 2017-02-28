
module Xcov
  class ErrorHandler

    class << self

      def handle_error(output)
        case output
        when /XccoverageFileNotFound/
          print "Unable to find any .xccoverage file."
          print "Make sure you have enabled 'Gather code coverage' setting on your scheme settings."
          print "Alternatively you can provide the full path to your .xccoverage file."
        when /UnableToParseXccoverageFile/
          print "There was an error converting the .xccoverage file to json."
        when /CoverageUnderThreshold/
          print "The build has been marked as failed because minimum overall coverage has not been reached."
        when /UnableToMapJsonToXcovModel/
          print "There was an error converting the json file to xcov's model objects."
        end
        raise "Error creating your coverage report - see the log above".red
      end

      def handle_error_with_custom_message(error, custom_message)
        print custom_message
        handle_error error
      end

      private

      def print(text)
        UI.message text.red
      end

    end

  end
end
