################################################################################
# Sample Project for middleman-pagegroups
################################################################################

#==========================================================================
# Conflicting resources
#  middleman-pagegroups uses Middleman's resource map to determine
#  relationships between pages in groups. Be sure to activate other
#  extensions that might manipulate the resource map before activating
#  middleman-pagegroups, such as MiddlemanTargets.
#==========================================================================
# activate :MiddlemanTargets


#==========================================================================
# Extension Setup
#  Note that middleman-targets adds configuration parameters to the base
#  Middleman application (supported feature in 4.0+); there are *not*
#  extension options. Additionally if middleman-targets is in your Gemfile
#  then it is also activated automatically.
#==========================================================================
activate :MiddlemanPageGroups do |config|

  # Indicate whether or not numeric file name prefixes used for sorting
  # pages should be eliminated during output. This results in cleaner
  # URI's. Helpers such as `page_name` and Middleman helpers such as
  # `page_class` will reflect the pretty name.
  config.strip_file_prefixes = true

  # Indicates whether or not Middleman's built-in `page_class` helper is
  # extended to include the page_group and page_name.
  config.extend_page_class = true

  # the following options provide defaults for the built-in helpers, and
  # also work with the sample partials if you choose to install them.
  # They'll also work in your own partials and helpers, of course.

  # Default css class for the nav_breadcrumbs helper/partial.
  config.nav_breadcrumbs_class = 'breadcrumbs'

  # Default css class for the nav_breadcrumbs_alt helper/partial.
  config.nav_breadcrumbs_alt_class = 'breadcrumbs'

  # Default "current page" label for the nav_breadcrumbs_alt helper/partial.
  config.nav_breadcrumbs_alt_label = 'Current page'

  # Default css class for the nav_brethren helper/partial.
  config.nav_brethren_class = 'table_contents'

  # Default css class for the nav_brethren_index helper/partial.
  config.nav_brethren_index_class = 'related-topics'

  # Default css class for the nav_legitimate_children helper/partial.
  config.nav_legitimate_children_class = 'table_contents'

  # Default css class for the nav_prev_next helper/partial.
  config.nav_prev_next_class = 'navigate_prev_next'

  # Default "previous" label text for the nav_prev_next helper/partial.
  config.nav_prev_next_label_prev = 'Previous'

  # Default "next" label text for the nav_prev_next helper/partial.
  config.nav_prev_next_label_next = 'Next'

  # Default css class for the nav_toc_index helper/partial.
  config.nav_toc_index_class = 'help_map'

end


#==========================================================================
# Regular Middleman Setup
#==========================================================================

set :relative_links, true
activate :syntax


#==========================================================================
# Helpers
#  These helpers are used by the sample project only; there's no need
#  to keep them around in your own projects.
#==========================================================================

# Methods defined in the helpers block are available in templates
helpers do

  def product_name
    'middleman-pagegroups'
  end

  def product_version
    '1.0.2'
  end

  def product_uri
    'https://github.com/middlemac'
  end

end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
