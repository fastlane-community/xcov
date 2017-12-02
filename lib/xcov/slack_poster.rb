
module Xcov
  class SlackPoster

    def run(report)
      return if Xcov.config[:skip_slack]
      return if Xcov.config[:slack_url].to_s.empty?

      require 'slack-notifier'
      notifier = Slack::Notifier.new(Xcov.config[:slack_url])
      notifier.username = Xcov.config[:slack_username]

      if Xcov.config[:slack_channel].to_s.length > 0
        notifier.channel = Xcov.config[:slack_channel]
        notifier.channel = ('#' + notifier.channel) unless ['#', '@'].include?(notifier.channel[0])
      end

      attachments = []

      report.targets.each do |target|
        attachments << {
          text: "#{target.name}: #{target.displayable_coverage}",
          color: target.coverage_color,
          short: true
        }
      end

      begin
        result = notifier.ping(
          Xcov.config[:slack_message],
          icon_url: 'https://s3-eu-west-1.amazonaws.com/fastlane.tools/fastlane.png',
          attachments: attachments
        )

        UI.message 'Successfully sent Slack notification'.green

      rescue Exception => e
        UI.error "xcov failed to upload results to slack. error: #{e.to_s}"
      end
    end

  end
end
