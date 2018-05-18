middleman-pagegroups change log
===============================

- Version 1.0.8 / 2018-May-18

  - Finalize 1.0.8
  - Proposed fix for #2

- Version 1.0.7 / 2018-April-25

  - Correct the version to non-wip.

- Version 1.0.7.wip / 2018-April-25

  - - Bump to version 1.0.7.
    - Added a convenient `legitimate?` field to each resource.
    - Fixed some source code formatting.
    - Added a `rake testq` task to squelch annoying errout, and removed the old
      customer formatter with deprecated methods.
    - Updated the documentation project.
  - Updated README with better Github link. No version bump.
  - Version 1.0.6 changes:
      - Fixed bad documentation project. No idea how this was missed.
      - Updated Cucumber test for version 1.0.5 fixture changes.
      - Added API documentation to project root, and link to it from readme.

- Version 1.0.5 / 2016-June-29

  - Version 1.0.5 changes:
      - Fix using page order prefixes for nested folders.
      - Updated fixture application to use deeply nested folders.

- Version 1.0.4 / 2016-May-14

  - Version 1.0.4 Changes:
      - Better Rakefile for version management.
      - Added capybara development dependency to fix broken testing.
      - Sample project now refers to non-local file.
  - Version 1.0.4
      - Very minor Rakefile cleanup.
      - tbd

- Version 1.0.3 / 2016-May-10

  - Support ordering on directories; documentation
    - Replaced Middleman's `resource.parent` with fixed version that respects
      changes to output directory names.
    - Fixed an issue wherein HTML files in renamed directories weren't having
      their paths corrected.
    - Added YARDOC comments and features.
    - Added initial Cucumber testing support.
    - Added significant release-related functionality to the Rakefile.
    Rakefile now generates the change log.

- Version 1.0.2 / 2016-May-09

  - Bump to v1.0.2 to fix files that don't have a page order associated with them
  - Cleanup
    - Cleanup README.
    - Remove .gem that should not have been committed.

- Version 1.0.1 / 2016-May-09

  - Bump to v1.0.1 to repair bad sample project
  - Added RubyGems badge to README

- Version 1.0.0 / 2016-April-02

  - Version 1.0.0
