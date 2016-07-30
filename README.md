![/assets_readme/gather_coverage.png](/assets_readme/logo.png)
-------
[![Twitter: @carlostify](https://img.shields.io/badge/contact-@carlostify-blue.svg?style=flat)](https://twitter.com/carlostify)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/nakiostudio/xcov/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/xcov.svg?style=flat)](http://rubygems.org/gems/xcov)
[![Gem Downloads](https://img.shields.io/gem/dt/xcov.svg?style=flat)](http://rubygems.org/gems/xcov)

**xcov** is a friendly visualizer for Xcode's code coverage files.

## Installation
```
sudo gem install xcov
```

## Features
* Built on top of [Fastlane](https://fastlane.tools), you can easily plug it on to your CI environment.
* Blacklisting of those files which coverage you want to ignore.
* Minimum acceptable coverage percentage.
* Nice HTML reports.

![/assets_readme/report.png](/assets_readme/report.png)

* Slack integration.

![/assets_readme/slack_integration.png](/assets_readme/slack_integration.png)

## Requirements
In order to make *xcov* run you must:
* Use Xcode 7.
* Have the latest version of Xcode command line tools.
* Set your project scheme as **shared**.
* Enable the **Gather coverage data** setting available on your scheme settings window.

![/assets_readme/gather_coverage.png](/assets_readme/gather_coverage.png)

## Usage
*xcov* analyzes the `.xccoverage` files created after running your tests therefore, before executing xcov, you need to run your tests with either `Xcode`, `xcodebuild` or [scan](https://github.com/fastlane/scan). Once completed, obtain your coverage report by providing a few parameters:
```
xcov -w LystSDK.xcworkspace -s LystSDK -o xcov_output
```

### Parameters allowed
* `--workspace` `-w`: Path of your `xcworkspace` file.
* `--project` `-p`: Path of your `xcodeproj` file (optional).
* `--scheme` `-s`: Scheme of the project to analyze.
* `--output_directory` `-o`: Path for the output folder where the report files will be saved.
* `--derived_data_path` `-j`: Path of your project `Derived Data` folder (optional).
* `--minimum_coverage_percentage` `-m`: Raise exception if overall coverage percentage is under this value (ie. 75).
* `--include_test_targets`: Enables coverage reports for `.xctest` targets.
* `--ignore_file_path` `-x`: Relative or absolute path to the file containing the list of ignored files.
* `--exclude_targets`: Comma separated list of targets to exclude from coverage report.
* `--slack_url` `-i`: Incoming WebHook for your Slack group to post results (optional).
* `--slack_channel` `-e`: Slack channel where the results will be posted (optional).
* `--html_report`: Enables the creation of a html report. Enabled by default (optional).
* `--json_report`: Enables the creation of a json report (optional).
* `--markdown_report`: Enables the creation of a markdown report (optional).
* `--skip_slack`: Add this flag to avoid publishing results on Slack (optional).

_**Note:** All paths you provide should be absolute and unescaped_

### Ignoring files
You can easily ignore the coverage for a specified set of files by adding their filenames to the *ignore file* specified with the `--ignore_file_path` parameter (this file is `.xcovignore` by default). You can also specify a wildcard expression for matching a group of files.

Each one of the filenames you would like to ignore must be prefixed by the dash symbol `-`. In addition you can comment lines by prefixing them by `#`. Example:

```yaml
# Api files
- LSTSessionApi.swift
- LSTComponentsApi.swift
- LSTNotificationsApi.swift

# Managers
- LSTRequestManager.m
- LSTCookiesManager.m

# Utils
- LSTStateMachine.swift

# Exclude all files ending by "View.swift"
- .*View.swift
```

### [Fastlane](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Actions.md)
*Fastlane 1.61.0* includes *xcov* as a custom action. You can easily create your coverage reports as follows:
```ruby
xcov(
  workspace: "YourWorkspace.xcworkspace",
  scheme: "YourScheme",
  output_directory: "xcov_output"
)  
```

### [Danger](https://danger.systems)
With the *Danger* plugin you can receive your coverage reports directly on your pull requests. You can find more information on the plugin repository available [here](https://github.com/nakiostudio/danger-xcov).

![screenshot](http://www.nakiostudio.com/danger-xcov.png)

## Contributors

* [nakiostudio](https://github.com/nakiostudio)
* [opfeffer](https://github.com/opfeffer)
* [stevenreinisch](https://github.com/stevenreinisch)
* [hds](https://github.com/hds)
* [michaelharro](https://github.com/michaelharro)

## License
This project is licensed under the terms of the MIT license. See the LICENSE file.
