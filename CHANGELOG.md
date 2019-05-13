## Changelog

### v.1.5.1
* Added support to specify direct path to xccoverage/xccovreport file (by **cmarchal**).

### v.1.5.0
* Xcode 10 fixes (by **aaroncrespo**).
* Fixed Coveralls issue when project structure contains spaces (by **ngs**).

### v.1.4.3
* Fixed target coverage calculation.

### v.1.4.2
* Fixed issue parsing `DISABLE_COVERALLS` option (by **chrisballinger**).

### v.1.4.1
* Added option to disable automatic Coveralls submission (by **chrisballinger**).
* Default values always computed (by **revolter**).
* Hidden Coveralls token from logs (by **chrisballinger**).

### v.1.4.0
* Supported `.xccovreport` format introduced by Xcode 9.3. If you want to continue parsing `.xccoverage`
files use the `legacy_support` option of xcov.

### v.1.3.5
* Fixed compatibility issue with Fastlane 2.86.0.

### v.1.3.3
* Fixed Slack notifications.

### v.1.3.2
* Fixed dependencies clonflict (by **thelvis4**).
* Fixed bug loading .xcovignore file when fastlane folder is hidden (by **thelvis4**).

### v.1.3.1
* Fixed empty `slack_url` causing crash (by **initFabian**).

### v.1.3.0
* Fixed report creation when write access to `/tmp` folder is not available (by **michaelharro**).
* Sorted targets alphabetically.
* Two digits precision for displayable coverage values.

### v.1.2.0
* Customize Slack message and user (by **BennX**).

### v.1.1.2
* Set Fastlane minimum version compatible to `2.19.2`.

### v.1.1.1
* Fixed compatibility issue with `danger-xcov`.

### v.1.1.0
* Added [Coveralls](https://coveralls.io) support.
* Improved error handling.

### v.1.0.1
* *xcovignore* entries now case-insensitive (by **thelvis4**).

### v.1.0.0
* Added `--only_project_targets` option that displays the coverage only for main project targets, e.g. skip Pods targets
(by **thelvis4**).
* Measured coverage considering number of lines (by **thelvis4**).

### v.0.12.5
* Fixed sorting by coverage percentage (by **thelvis4**).

### v.0.12.4
* Fastlane 2.0 compatibility (by **KrauseFx**).

### v.0.12.3
* Fixed `fastlane_core` dependency.

### v.0.12.2
* Fixed a compatibility issue with `fastlane_core` 0.57.0 (by **thelvis4**).

### v.0.12.1
* Fixed the bug when `danger-xcov` raised a exception if `source_directory` wasn't explicitly defined (by **thelvis4**).

### v.0.12
* Implemented ability to ignore directories (by **thelvis4**).
* Improved validation of `derived_data_path` option (by **thelvis4**).
* Changed `exclude_targets` option so that it will also accept an array (by **tapi**).
* Added `include_targets` option to limit reporting of targets to specific options (by **tapi**).

### v.0.11.3
* Fixed appearance of ignored files on markdown reports (by cdzombak).

### v.0.11.2
* Allowed `FastlaneCore` versions greater than `1.0.0`.

### v.0.11.1
* Fixed problem involving markdown reports and encoding issues.

### v.0.11
* **[BREAKING]** Fixed bug where no *.xccoverage* files could be found (by **michaelharro**). *Note: If you
were manually escaping the paths passed as arguments to xcov that is no longer needed as this change does
that for you.*
* Improved json reports (by **hds**).

### v.0.10
* Added options to export reports as json or markdown files (by **hds**).

### v.0.9
* Added functionality specific for the [Danger]() plugin.
* Added Danger plugin information to project's README.

### v.0.8
* Fixed a compatibility issue with last versions of FastlaneCore.

### v.0.7
* Ignore file allows wildcards for matching a group of files (by **stevenreinisch**)
* New `exclude_targets` option to exclude reporting for the targets given (by **stevenreinisch**)

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
