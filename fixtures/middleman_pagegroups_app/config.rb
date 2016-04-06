activate :MiddlemanPageGroups do |options|

  options[:strip_file_prefixes] = true
  options[:extend_page_class] = true

  options[:nav_breadcrumbs_class] = 'breadcrumbs'
  options[:nav_breadcrumbs_alt_class] = 'breadcrumbs'
  options[:nav_breadcrumbs_alt_label] = 'Current page'
  options[:nav_brethren_class] = 'table_contents'
  options[:nav_brethren_index_class] = 'related-topics'
  options[:nav_legitimate_children_class] = 'table_contents'
  options[:nav_prev_next_class] = 'navigate_prev_next'
  options[:nav_prev_next_label_prev] = 'Previous'
  options[:nav_prev_next_label_next] = 'Next'
  options[:nav_toc_index_class] = 'help_map'

end
