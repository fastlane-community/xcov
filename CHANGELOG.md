## Changelog

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
