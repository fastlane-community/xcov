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
* `--slack_url` `-i`: Incoming WebHook for your Slack group to post results (optional).
* `--slack_channel` `-e`: Slack channel where the results will be posted (optional).
* `--skip_slack`: Add this flag to avoid publishing results on Slack (optional).

### Ignoring files
You can easily ignore the coverage for a specified set of files by adding their filenames to the *ignore file* specified with the `--ignore_file_path` parameter (this file is `.xcovignore` by default). You can also specify a regular expression for matching a group of files.

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

# Exclude all detail views
- .*DetailView\.(?:m|swift)$
```

### [Fastlane](https://github.com/fastlane/fastlane/blob/master/docs/Actions.md)
*Fastlane 1.61.0* includes *xcov* as a custom action. You can easily create your coverage reports as follows:
```ruby
xcov(
  workspace: "YourWorkspace.xcworkspace",
  scheme: "YourScheme",
  output_directory: "xcov_output"
)  
```

## Changelog

### v.0.6
* Ignored coverage for a specified list of files

### v.0.5
* Fixed bug using the `derived_data_path` option
* Fixed bug sorting multiple `.xccoverage` files by datetime

### v.0.4
* Additional flag to enable coverage reports for `.xctest` targets

### v.0.3
* Raised exception when the minimum coverage threshold is not reached (by **opfeffer**)

### v.0.2
* Fixed bug expanding/collapsing rows with same filename
* Added Fastlane integration to README

## Contributors

* [nakiostudio](https://github.com/nakiostudio)
* [opfeffer](https://github.com/opfeffer)

## License
This project is licensed under the terms of the MIT license. See the LICENSE file.
