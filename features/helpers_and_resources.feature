Feature: Provide helpers and resource items to make multiple targets easy to manage.

  As a software developer
  I want to use helpers and resource items
  In order to enable automatic navigation of items.
  
  Background:
    Given a built app at "middleman_pagegroups_app"
    
  Scenario:
    Source files and directories with prefixes must be built without 
    prefixes, and all files must be present when built.
    When I cd to "build"
    Then the following directories should exist:
      | sub_folder_01 |
      | sub_folder_02 |
    And the following files should exist:
      | index.html                        |
      | sub_folder_01/index.html          |
      | sub_folder_01/sibling_one.html    |
      | sub_folder_01/sibling_two.html    |
      | sub_folder_01/sibling_three.html  |
      | sub_folder_02/index.html          |
      | sub_folder_02/sibling_one.html    |
      | sub_folder_02/sibling_two.html    |
      | sub_folder_02/not_legitimate.html |
    And the following directories should not exist:
      | 20_sub_folder_02 |
    And the following files should not exist:
      | index.html    |
      | sub_folder_01/10_sibling_one.html    |
      | sub_folder_01/20_sibling_two.html    |
      | sub_folder_01/30_sibling_three.html  |

  
  Scenario: The CSS Class Helpers provide correct values when used.
    When I cd to "build"
    And the file "index.html" should contain 'nav_breadcrumbs_alt_class: breadcrumbs'
    And the file "index.html" should contain 'nav_breadcrumbs_alt_label: Current page'
    And the file "index.html" should contain 'nav_breadcrumbs_class: breadcrumbs'
    And the file "index.html" should contain 'nav_brethren_class: table_contents'
    And the file "index.html" should contain 'nav_brethren_index_class: related-topics'
    And the file "index.html" should contain 'nav_legitimate_children_class: table_contents'
    And the file "index.html" should contain 'nav_prev_next_class: navigate_prev_next'
    And the file "index.html" should contain 'nav_prev_next_label_next: Next'
    And the file "index.html" should contain 'nav_prev_next_label_prev: Previous'
    And the file "index.html" should contain 'nav_toc_index_class: breadcrumbs'


  Scenario: The extended page_classes helper provides correct values when used.
    When I cd to "build"
    And the file "index.html" should contain 'page_classes: index source'
    When I cd to "sub_folder_01"
    And the file "index.html" should contain 'page_classes: index sub_folder_01'
    And the file "sibling_one.html" should contain 'page_classes: sibling_one sub_folder_01'
    And the file "sibling_two.html" should contain 'page_classes: sibling_two sub_folder_01'
    And the file "sibling_three.html" should contain 'page_classes: sibling_three sub_folder_01'
    When I cd to "../sub_folder_02"
    And the file "index.html" should contain 'page_classes: index sub_folder_02'
    And the file "sibling_one.html" should contain 'page_classes: sibling_one sub_folder_02'
    And the file "sibling_two.html" should contain 'page_classes: sibling_two sub_folder_02'
    And the file "not_legitimate.html" should contain 'page_classes: not_legitimate sub_folder_02'


  Scenario:
    The resource extensions must deliver correct results when used, ensuring
    that helpers and partials will have access to the correct data for
    rendering. 
    When I cd to "build"
    And the file "index.html" should contain 'current_resource.breadcrumbs:[#&lt;Middleman::Sitemap::Resource path=index.html&gt;]'
    And the file "index.html" should contain 'current_resource.brethren:[]'
    And the file "index.html" should contain 'current_resource.brethren_next:nil'
    And the file "index.html" should contain 'current_resource.brethren_previous:nil'
    And the file "index.html" should contain 'current_resource.group_count:1'
    And the file "index.html" should contain 'current_resource.legitimate_children:[#&lt;Middleman::Sitemap::Resource path=sub_folder_01/index.html&gt;, #&lt;Middleman::Sitemap::Resource path=20_sub_folder_02/index.html&gt;]'
    And the file "index.html" should contain 'current_resource.navigator_eligible:nil'
    And the file "index.html" should contain 'current_resource.page_group:source'
    And the file "index.html" should contain 'current_resource.page_name:index'
    And the file "index.html" should contain 'current_resource.page_sequence:nil'
    And the file "index.html" should contain 'current_resource.parent:nil'
    And the file "index.html" should contain 'current_resource.sort_order:0'


  Scenario:
    The resource extensions must deliver correct results when used, ensuring
    that helpers and partials will have access to the correct data for
    rendering. 
    When I cd to "build/sub_folder_01/"
    And the file "sibling_two.html" should contain 'current_resource.breadcrumbs:[#&lt;Middleman::Sitemap::Resource path=index.html&gt;, #&lt;Middleman::Sitemap::Resource path=sub_folder_01/index.html&gt;, #&lt;Middleman::Sitemap::Resource path=sub_folder_01/20_sibling_two.html&gt;]'
    And the file "sibling_two.html" should contain 'current_resource.brethren:[#&lt;Middleman::Sitemap::Resource path=sub_folder_01/10_sibling_one.html&gt;, #&lt;Middleman::Sitemap::Resource path=sub_folder_01/30_sibling_three.html&gt;]'
    And the file "sibling_two.html" should contain 'current_resource.brethren_next:#&lt;Middleman::Sitemap::Resource path=sub_folder_01/30_sibling_three.html&gt;'
    And the file "sibling_two.html" should contain 'current_resource.brethren_previous:#&lt;Middleman::Sitemap::Resource path=sub_folder_01/10_sibling_one.html&gt;'
    And the file "sibling_two.html" should contain 'current_resource.group_count:3'
    And the file "sibling_two.html" should contain 'current_resource.legitimate_children:[]'
    And the file "sibling_two.html" should contain 'current_resource.navigator_eligible:true'
    And the file "sibling_two.html" should contain 'current_resource.page_group:sub_folder_01'
    And the file "sibling_two.html" should contain 'current_resource.page_name:sibling_two'
    And the file "sibling_two.html" should contain 'current_resource.page_sequence:2'
    And the file "sibling_two.html" should contain 'current_resource.parent:#&lt;Middleman::Sitemap::Resource path=sub_folder_01/index.html&gt;'
    And the file "sibling_two.html" should contain 'current_resource.sort_order:20'


  Scenario:
    The resource extensions must deliver correct results when used, ensuring
    that helpers and partials will have access to the correct data for
    rendering. 
    When I cd to "build/sub_folder_02/"
    And the file "sibling_one.html" should contain 'current_resource.breadcrumbs:[#&lt;Middleman::Sitemap::Resource path=index.html&gt;, #&lt;Middleman::Sitemap::Resource path=20_sub_folder_02/index.html&gt;, #&lt;Middleman::Sitemap::Resource path=20_sub_folder_02/sibling_one.html&gt;]'
    And the file "sibling_one.html" should contain 'current_resource.brethren:[#&lt;Middleman::Sitemap::Resource path=20_sub_folder_02/sibling_two.html&gt;]'
    And the file "sibling_one.html" should contain 'current_resource.brethren_next:#&lt;Middleman::Sitemap::Resource path=20_sub_folder_02/sibling_two.html&gt;'
    And the file "sibling_one.html" should contain 'current_resource.brethren_previous:nil'
    And the file "sibling_one.html" should contain 'current_resource.group_count:2'
    And the file "sibling_one.html" should contain 'current_resource.legitimate_children:[]'
    And the file "sibling_one.html" should contain 'current_resource.navigator_eligible:nil'
    And the file "sibling_one.html" should contain 'current_resource.page_group:sub_folder_02'
    And the file "sibling_one.html" should contain 'current_resource.page_name:sibling_one'
    And the file "sibling_one.html" should contain 'current_resource.page_sequence:1'
    And the file "sibling_one.html" should contain 'current_resource.parent:#&lt;Middleman::Sitemap::Resource path=20_sub_folder_02/index.html&gt;'
    And the file "sibling_one.html" should contain 'current_resource.sort_order:10'

