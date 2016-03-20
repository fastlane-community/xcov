
module Xcov
  class IgnoreHandler

    def read_ignore_file
      require "yaml"
      ignore_file_path = Xcov.config[:ignore_file_path]
      ignore_list = []
      begin
        ignore_list = YAML.load_file(ignore_file_path)
      rescue
        Helper.log.info "Skipping file blacklisting as no ignore file was found at path #{ignore_file_path}".yellow
      end

      ignore_list
    end

  end
end
