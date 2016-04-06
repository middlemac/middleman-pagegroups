Feature: Provide helpers and resource items to make multiple targets easy to manage.

  As a software developer
  I want to use helpers and resource items
  In order to deploy different versions of my project
  
  Scenario: Build with the default target
    Given a built app at "middleman_pagegroups_app"
    When I cd to "custom_build_dir (pro)"
    And the file "index.html" should contain "Insult: NO"
    And the file "index.html" should contain "TargetName: pro"
    And the file "index.html" should contain "TargetFree: NO"
    And the file "index.html" should contain "TargetValueForSampleKey: You are a valued contributor to our balance sheet!"
    And the file "index.html" should contain "CurrentPageValidFeatures: [:grants_wishes]"
    And the file "index.html" should contain 'src="/pro-root.png"'
    And the file "index.html" should contain 'src="/all-root-logo.png"'
    And the file "index.html" should contain 'src="/images/pro-image.png"'
    And the file "index.html" should contain 'src="/images/all-logo.png"'
