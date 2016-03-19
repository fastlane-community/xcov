
module Xcov
  class IgnoreHandler

    def read_ignore_file
      require "yaml"
      ignore_list = []
      begin
        ignore_list = YAML.load_file(".xcovignore")
      rescue
        Helper.log.info "Skipping file blacklisting as no .xcovignore file was found".yellow
      end

      ignore_list
    end

  end
end
