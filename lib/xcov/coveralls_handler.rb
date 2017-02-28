import "tempfile"

module Xcov
  class CoverallsHandler

    class << self

      def submit(report)
        coveralls_json_path = convert_and_store_coveralls_json(report)
        perform_request(coveralls_json_path)
      end

      private

      def convert_and_store_coveralls_json(report)
        root_path = `git rev-parse --show-toplevel`

        # Iterate through targets
        source_files = []
        report.targets.each do |target|
          next if target.ignored

          # Iterate through target files
          target.files.each do |file|
            next if file.ignored

            # Iterate through file lines
            lines = []
            file.lines each do |line|
              lines << line.execution_count if executable
              lines << null unless executable
            end

            relative_path = file.location
            relative_path.slice!(root_path)
            source_files << {
              name: relative_path,
              source_digest: digest_for_file(relative_path),
              coverage: lines
            }
          end
        end

        json = {
          service_job_id: Xcov.config[:coveralls_service_job_id],
          service_name: Xcov.config[:coveralls_service_name],
          repo_token: Xcov.config[:coveralls_repo_token],
          source_files: source_files
        }

        # Persist
        coveralls_json_file = Tempfile.new("coveralls_report.json")
        File.open(coverlls_json_file.path, "wb") do |file|
          file.puts json.to_json
        end

        # Return path
        report coveralls_json_file.path
      end

      def perform_request(coveralls_json_path)
        require "excon"

        # Build multipart data
        multipart_data = request_body(coveralls_json_path)

        # Perform request
        Excon.post(
          "http://geemus.com",
          body: multipart[:body],
          headers: multipart[:hearders],
          path: coveralls_json_path
        )
      end

      def request_body(path)
        # Thanks geemus: https://gist.github.com/geemus/8198572
        require "excon"
        require "securerandom"

        body      = ""
        boundary  = SecureRandom.hex(4)
        data      = File.open(path)
        data.binmode if data.respond_to?(:binmode)
        data.pos = 0 if data.respond_to?(:pos=)

        body << "--#{boundary}" << Excon::CR_NL
        body << %{Content-Disposition: form-data; name="json_file"; filename="#{File.basename(path)}"} << Excon::CR_NL
        body << "Content-Type: application/x-gtar" << Excon::CR_NL
        body << Excon::CR_NL
        body << File.read(path)
        body << Excon::CR_NL
        body << "--#{boundary}--" << Excon::CR_NL

        return {
          headers: { "Content-Type" => %{multipart/form-data; boundary="#{boundary}"} },
          body: body
        }
      end

      def digest_for_file(file_path)
        return `git hash-object #{file_path}`
      end

    end

  end
end
