require "fastlane_core"
require "xcodeproj"

module FastlaneCore
  class Project

    # Returns project targets
    def targets
      project_path = get_project_path
      return [] if project_path.nil?

      proj = Xcodeproj::Project.open(project_path)

      proj.targets.map do |target|
       target.name
     end
    end

    private

    def get_project_path
      # Given the workspace and scheme, we can compute project path
      if workspace?
        if options[:workspace] && options[:scheme]
          build_settings(key: "PROJECT_FILE_PATH")
        end
      else
        options[:project]
      end
    end

  end
end
