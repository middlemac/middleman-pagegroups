middleman-pagegroups change log
===============================

- Version 1.0.6 changes:

  - Fixed bad documentation project. No idea how this was missed.
  - Updated Cucumber test for version 1.0.5 fixture changes.
  - Added API documentation to project root, and link to it from readme.


- Version 1.0.5 changes:

  - Fix using page order prefixes for nested folders.
  - Updated fixture application to use deeply nested folders.

- Version 1.0.4 Changes:

  - Better Rakefile for version management.
  - Added capybara development dependency to fix broken testing.
  - Sample project now refers to non-local file.


- Version 1.0.3 / 2016-May-11

  - Support ordering on directories; documentation
    - Replaced Middleman's `resource.parent` with fixed version that respects
      changes to output directory names.
    - Fixed an issue wherein HTML files in renamed directories weren't having
      their paths corrected.
    - Added YARDOC comments and features.
    - Added initial Cucumber testing support.
    - Added significant release-related functionality to the Rakefile.
    Rakefile now generates the change log.

- Version 1.0.2 / 2016-May-10

  - Bump to v1.0.2 to fix files that don't have a page order associated with them
  - Cleanup
    - Cleanup README.
    - Remove .gem that should not have been committed.

- Version 1.0.1 / 2016-May-10

  - Bump to v1.0.1 to repair bad sample project
  - Added RubyGems badge to README

- Version 1.0.0 / 2016-April-03

  - Version 1.0.0
