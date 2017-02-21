require 'middleman-core'
require 'middleman-pagegroups/partials'

################################################################################
# This extension provides advanced navigation tools and helpers for grouping
# pages by topic and navigating between them. It includes support for tables
# of content, related pages, breadcrumbs, and more.
# @author Jim Derry <balthisar@gmail.com>
################################################################################
class MiddlemanPageGroups < ::Middleman::Extension


  ############################################################
  # Define the options that are to be set within `config.rb`
  # as extension options.
  ############################################################
  option :strip_file_prefixes,           true,             'If true leading numbers used for sorting files will be removed for presentation purposes.'
  option :extend_page_class,             true,             'If true then the page_class helper will be extended to include simple group and page_names.'

  option :nav_breadcrumbs_class,         nil,              'Default css class for the nav_breadcrumbs helper/partial.'
  option :nav_breadcrumbs_alt_class,     nil,              'Default css class for the nav_breadcrumbs_alt helper/partial.'
  option :nav_breadcrumbs_alt_label,     'Current page',   'Default "current page" label for the nav_breadcrumbs_alt helper/partial.'
  option :nav_brethren_class,            nil,              'Default css class for the nav_brethren helper/partial.'
  option :nav_brethren_index_class,      nil,              'Default css class for the nav_brethren_index helper/partial.'
  option :nav_legitimate_children_class, nil,              'Default css class for the nav_legitimate_children helper/partial.'
  option :nav_prev_next_class,           nil,              'Default css class for the nav_prev_next helper/partial.'
  option :nav_prev_next_label_prev,      'Previous',       'Default "previous" label text for the nav_prev_next helper/partial.'
  option :nav_prev_next_label_next,      'Next',           'Default "next" label text for the nav_prev_next helper/partial.'
  option :nav_toc_index_class,           nil,              'Default css class for the nav_toc_index helper/partial.'

  # @!group Extension Configuration

  # @!attribute [rw] options[:strip_file_prefixes]=
  # If `true` leading numbers used for sorting files will be removed for
  # presentation purposes. This makes it possible to neatly organize your
  # source files in their presentation order on your filesystem but output
  # nice filenames without ugly prefix numbers.
  # @param [Boolean] value `true` or `false` to enable or disable this feature.
  # @return [Boolean] Returns the current value of this option.

  # @!attribute [rw] options[:extend_page_class]=
  # If true then the default **Middleman** `page_class` helper will be extended
  # to include simple `group` and `page_name` for each resource.
  # @param [Boolean] value `true` or `false` to enable or disable this feature.
  # @return [Boolean] Returns the current value of this option.

  # @!attribute [rw] options[:nav_breadcrumbs_class]=
  # Default css class for the `nav_breadcrumbs` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_breadcrumbs_alt_class]=
  # Default css class for the `nav_breadcrumbs_alt` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_breadcrumbs_alt_label]=
  # Default "current page" label for the `nav_breadcrumbs_alt` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_brethren_class]=
  # Default css class for the `nav_brethren` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_brethren_index_class]=
  # Default css class for the `nav_brethren_index` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_legitimate_children_class]=
  # Default css class for the `nav_legitimate_children` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_prev_next_class]=
  # Default css class for the `nav_prev_next` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_prev_next_label_prev]=
  # Default "previous" label text for the `nav_prev_next` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_prev_next_label_next]=
  # Default "next" label text for the `nav_prev_next` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!attribute [rw] options[:nav_toc_index_class]=
  # Default css class for the `nav_toc_index` helper/partial.
  # @param [String] value The `class` attribute value to use for this item’s
  #   containing element.
  # @return [String] Returns the current value of this option.

  # @!endgroup


  ############################################################
  #  Sitemap manipulators.
  #    Add new methods to each resource.
  ############################################################

  #--------------------------------------------------------
  # We want to handle shallower paths first, and ensure
  # that for any directory the index_file is first. This
  # gives us the ability to rename our directories if the
  # parent directory is to be renamed.
  # @!visibility private
  #--------------------------------------------------------
  def resource_sort_comparator( x, y )
    x_length = Pathname(x.path).each_filename.to_a.count
    x_basename = File.basename(x.path)
    x_dirname = File.dirname(x.path)
    y_length = Pathname(y.path).each_filename.to_a.count
    y_basename = File.basename(y.path)
    y_dirname = File.dirname(y.path)

    if x_length != y_length
      return x_length <=> y_length
    else
      if [x_basename, y_basename].include?(app.config[:index_file])
        # If either is an index file, favor the index file.
        # If both are index files, favor the path.
        if x_basename == y_basename
          return x_basename <=> y_basename
        else
          return x_basename == app.config[:index_file] ? -1 : 1
        end
      else
        # If the dir names are the same, favor the basename,
        # otherwise favor the entire path name.
        if x_dirname == y_dirname
          return x_basename <=> y_basename
        else
          return x_dirname <=> y_dirname
        end
      end
    end
  end


    #--------------------------------------------------------
  # Add our own resource methods to each resource in the
  # site map.
  # @!visibility private
  #--------------------------------------------------------
  def manipulate_resource_list(resources)

    resources.sort { |a,b| resource_sort_comparator(a,b) }
        .each do |resource|

      #--------------------------------------------------------
      # Return the parent of the resource. This implementation
      # corrects a bug in **Middleman** as of 4.1.7 wherein
      # **Middleman** doesn’t return the parent if the the
      # directory has been renamed for output.
      # @return [Sitemap::Resource] The resource instance of
      #   the resource’s parent.
      #--------------------------------------------------------
      def resource.parent
        root = path.sub(/^#{::Regexp.escape(traversal_root)}/, '')
        parts = root.split('/')

        tail = parts.pop
        is_index = (tail == @app.config[:index_file])

        if parts.empty?
          return is_index ? nil : @store.find_resource_by_path(@app.config[:index_file])
        end

        test_expr = parts.join('\\/')
        # eponymous reverse-lookup
        found = @store.resources.find do |candidate|
          candidate.path =~ %r{^#{test_expr}(?:\.[a-zA-Z0-9]+|\/)$}
        end

        if found
          found
        else
          parts.pop if is_index
          @store.find_resource_by_path("#{parts.join('/')}/#{@app.config[:index_file]}")
        end
      end

      #--------------------------------------------------------
      # Make `page_name` available for each resource. This is
      # the file’s base name after any renaming has occurred.
      # Useful for assigning classes, etc.
      # @return [String] The `page_name` of the current page.
      #--------------------------------------------------------
      def resource.page_name
        File.basename( self.destination_path, '.*' )
      end


      #--------------------------------------------------------
      # Make `page_group` available for each resource.
      # Useful for for assigning classes, and/or group
      # conditionals.
      # @return [String] The `page_group` of the current page.
      #--------------------------------------------------------
      def resource.page_group
        result = File.basename( File.split( self.destination_path )[0] )
        if result == '.'
          result = @app.config[:source]
        end
        result
      end


      #--------------------------------------------------------
      # Returns the quantity of pages in the current page’s
      # group, including this current page, i.e., the number
      # of `brethren + 1`.
      # @return [Integer] The total number of pages in the
      #   this page’s current group.
      #--------------------------------------------------------
      def resource.group_count
        self.brethren.count + 1
      end


      #--------------------------------------------------------
      # Returns the page sort order or 0 if no page sort order
      # was applied.
      #
      # Pages without a sort order can still be linked to;
      # they simply aren't brethren or legitimate children,
      # and so don’t participate in any of the automatic
      # navigation features.
      # @return [Integer] The current resource’s sort order
      #   within its group, or 0 if no sort order was applied.
      #--------------------------------------------------------
      def resource.sort_order
        options[:sort_order]
      end


      #--------------------------------------------------------
      # Returns the page sequence amongst all of the brethren,
      # and can be used as a page number surrogate. The first
      # page is 1. Pages without a sort order will have a `nil`
      # `page_sequence`.
      # @return [Integer, Nil] The current page sequence of
      #   this resource among its brethren.
      #--------------------------------------------------------
      def resource.page_sequence
        if self.sort_order == 0
          return nil
        else
          self.siblings
            .find_all { |p| p.sort_order && p.sort_order != 0 && !p.ignored }
            .push(self)
            .sort_by { |p| p.sort_order }
            .find_index(self) + 1
        end
      end


      #--------------------------------------------------------
      # Returns an array of all of the siblings of this page,
      # taking into account their eligibility for display.
      #
      #  * is not already the current page.
      #  * has a `sort_order`.
      #  * is not ignored.
      #
      # The returned array will be sorted by each item’s
      # `sort_order`.
      # @return [Array<Sitemap::Resource>] An array of
      #   resources.
      #--------------------------------------------------------
      def resource.brethren
        self.siblings
          .find_all { |p| p.sort_order && p.sort_order != 0 && !p.ignored && p != self }
          .sort_by { |p| p.sort_order }
      end


      #--------------------------------------------------------
      # Returns the next sibling based on order, or `nil` if
      # there is no next sibling.
      # @return [Sitemap::Resource] The resource instance of
      #   the next sibling.
      #--------------------------------------------------------
      def resource.brethren_next
        if self.sort_order == 0
          return nil
        else
          return self.brethren.find { |p| p.sort_order > self.sort_order }
        end
      end


      #--------------------------------------------------------
      # Returns the previous sibling based on order, or `nil`
      # if there is no previous sibling.
      # @return [Sitemap::Resource] The resource instance of
      #   the previous sibling.
      #--------------------------------------------------------
      def resource.brethren_previous
        if self.sort_order == 0
          return nil
        else
          return self.brethren.reverse.find { |p| p.sort_order < self.sort_order }
        end
      end


      #--------------------------------------------------------
      # Determines whether a page is eligible to include a
      # previous/next page control. This is based on:
      #
      #  * The group is set to allow navigation via the
      #    `:navigate` front matter key.
      #  * This page is not excluded from navigation via the
      #    use of `:navigator => false` in its front matter.
      #  * This page has a `sort_order`.
      #
      # @return (Boolean) Returns `true` if this pages is
      #   eligible for a previous/next page control.
      #--------------------------------------------------------
      def resource.navigator_eligible?
        group_navigates = self.parent && self.parent.data['navigate'] == true
        self_navigates = !( self.data.key?('navigator') && self.data['navigator'] == false )

        group_navigates && self_navigates && self.sort_order != 0
      end


      #--------------------------------------------------------
      # Returns an array of all of the children of this
      # resource, taking into account their eligibility for
      # display. Each child is legitimate if it:
      #
      #  * has a sort_order.
      #  * is not ignored.
      #
      # The returned array will be sorted by each item’s
      # `sort_order`.
      #
      # @return [Array<Sitemap::Resource>] An array of
      #   resources.
      #--------------------------------------------------------
      def resource.legitimate_children
        self.children
          .find_all { |p| p.sort_order && p.sort_order != 0 && !p.ignored }
          .sort_by { |p| p.sort_order }
      end


      #--------------------------------------------------------
      # Returns an array of resources leading to this resource.
      # @return [Array<Sitemap::Resource>] An array of
      #   resources.
      #--------------------------------------------------------
      def resource.breadcrumbs
        hierarchy = [] << self
        hierarchy.unshift hierarchy.first.parent while hierarchy.first.parent
        hierarchy
      end


      #========================================================
      #  sort_order and destination_path
      #    Take this opportunity to gather page sort orders
      #    and rename pages so that they don't include sort
      #    order as part of their names.
      #
      #    Only X/HTML files with an `order` data key, or
      #    with an integer prefix + underscore will be
      #    considered for sort orders.
      #
      #    If :strip_file_prefixes, then additionally we will
      #    prettify the output page name.
      #========================================================
      strip = @app.extensions[:MiddlemanPageGroups].options[:strip_file_prefixes]
      page_name = File.basename(resource.path, '.*')
      path_part = File.dirname(resource.destination_path)
      file_renamed = false

      if resource.content_type && resource.content_type.start_with?('text/html', 'application/xhtml')

        # Set the resource's sort order if provided via various means.
        if resource.data.key?('order')
          # Priority for ordering goes to the :order front matter key.
          sort_order = resource.data['order']
        elsif ( match = /^(\d*?)_/.match(page_name) )
          # Otherwise if the file has an integer prefix we will use that.
          sort_order = match[1]
        elsif ( match = /^(\d*?)_/.match(path_part.split('/').last) ) && File.basename( resource.path ) == app.config[:index_file]
          # Otherwise if we're an index file then set the sort order based on
          # its containing group. Because we sorted the resources, we are sure
          # that this is the first resource to be processed in this directory.
          sort_order = match[1]
        else
          sort_order = nil
        end

        # Remove the sort order indicator from the file or directory name.
        # This will only change the output path for files that have a sort
        # order. Other files in a renamed directory that need to have their
        # paths changed will be changed below.
        if strip && sort_order

          path_parts = path_part.split('/')

          # Handle preceding path parts, first, if there's a grandparent (all
          # top level items have a parent and aren't part of this case). These
          # will have already been set because we've done shallower paths first.
          if resource.parent && resource.parent.parent
            parent_path_parts = File.dirname(resource.parent.destination_path).split('/')
            path_parts = parent_path_parts + path_parts[parent_path_parts.count..-1]
          end

          # Handle our immediate directory.
          path_parts.last.sub!(/^(\d*?)_/, '')

          # Join up everything and write the correct path.
          path_part = path_parts.join('/')
          name_part = page_name.sub( "#{sort_order}_", '') + File.extname( resource.path )
          if path_part == '.'
            resource.destination_path = name_part
          else
            resource.destination_path = File.join(path_part, name_part)
          end
          file_renamed = true
        end

        resource.options[:sort_order] = sort_order.to_i

      end
      
      unless file_renamed
      
        # For other files, check to see if there's an index file in this source
        # directory. If so then our rules state it will have a sort order, which
        # means we can ensure that our output path is without a sorting prefix.
        # If there is, then make sure OUR immediate destination directory is
        # the same as the index file’s, in case we've renamed it.
        index_file = [path_part, app.config[:index_file] ].join('/')
        index_found = resources.select { |r| r.path == index_file }[0]

        if strip && index_found && index_found.options[:sort_order]
          path_part = File.dirname(index_found.destination_path)
          name_part = File.basename(resource.destination_path)
          if path_part == '.'
            resource.destination_path = name_part
          else
            resource.destination_path = File.join(path_part, name_part)
          end

        end

      end


    end # resources.each

    resources

  end # manipulate_resource_list


  ############################################################
  #  Helpers
  #    Methods defined in this helpers block are available in
  #    templates.
  ############################################################

  helpers do


    #--------------------------------------------------------
    # Extend the built-in page_classes to include the naked
    # group and page name. The features of this helper are
    # enabled only if `options[:extend_page_class]` is
    # `true`.
    # @return [String] Returns the classes that correspond
    #   to the site hierarchy.
    # @group Extended Helpers
    #--------------------------------------------------------
    def page_classes
      if extensions[:MiddlemanPageGroups].options[:extend_page_class]
        "#{current_page.page_name} #{current_page.page_group} #{super}"
      else
        super
      end
    end


    #########################################################
    # partial-like helpers
    #   Let's build these in so the user can choose to use
    #   them instead of installing partials.
    #########################################################


    #--------------------------------------------------------
    # Generates a breadcrumbs structure as an `<ul>`. The
    # trailing element is the current page.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @return [String] An `<ul>` containing the breadcrumbs.
    #--------------------------------------------------------
    def nav_breadcrumbs( locals = {} )
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BREADCRUMBS).render(self, locals)
    end


    #--------------------------------------------------------
    # Generates the breadcrumbs structure, alternate form,
    # wherein the trailing element consists of a label
    # indicating “current page,” as an `<ul>`.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @option locals [String] :label The text for the label
    #   that means “Current page.”
    # @return [String] An `<ul>` containing the breadcrumbs.
    #--------------------------------------------------------
    def nav_breadcrumbs_alt( locals = {} )
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BREADCRUMBS_ALT).render(self, locals)
    end

    #--------------------------------------------------------
    # Generates a fuller list of related topics as a `<dl>`,
    # with a link to the page as the definition term and the
    # page’s front matter `:blurb` as the definition
    # definition.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @option locals [Sitemap::Resource] :start The resource
    #   from which to start the list. If not specified,
    #   then this resource’s brethren will be listed.
    # @return [String] A `<dl>` containing the list.
    #--------------------------------------------------------
    def nav_brethren( locals = {} )
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BRETHREN).render(self, locals)
    end


    #--------------------------------------------------------
    # Generates a condensed list of related topics as an
    # `<ul>`, omitting the `:blurb` front matter data.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @option locals [Sitemap::Resource] :start The resource
    #   from which to start the list. If not specified,
    #   then this resource’s brethren will be listed.
    # @return [String] An `<ul>` containing the list.
    #--------------------------------------------------------
    def nav_brethren_index(locals = {})
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BRETHREN_INDEX).render(self, locals)
    end


    #--------------------------------------------------------
    # Generates a fuller list of child topics as a `<dl>`,
    # with a link to the page as the definition term and the
    # page’s front matter `:blurb` as the definition
    # definition.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @option locals [Sitemap::Resource] :start The resource
    #   from which to start the list. If not specified,
    #   then this resource’s children will be listed.
    # @return [String] A `<dl>` containing the list.
    #--------------------------------------------------------
    def nav_legitimate_children(locals = {})
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_LEGITIMATE_CHILDREN).render(self, locals)
    end


    #--------------------------------------------------------
    # Generates a previous and next item as two anchors
    # nested within a `<div>`. With appropriate CSS this
    # can be rendered as a set of navigation buttons.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @option locals [String] :label_previous The text for
    #   the label that means “Previous page.”
    # @option locals [String] :label_next The text for the
    #   label that means “Next page.”
    # @return [String] A `<div>` containing the links.
    #--------------------------------------------------------
    def nav_prev_next(locals = {})
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_PREV_NEXT).render(self, locals)
    end


    #--------------------------------------------------------
    # Generate a nested `<ul>` structure representing the
    # complete table of contents from any particular
    # starting point.
    # @param [Hash] locals A hash of key-value pairs that
    #   are passed to the structure as local variables.
    # @option locals [String] :klass The `class` attribute
    #   value that should be assigned to the containing
    #   element.
    # @option locals [Sitemap::Resource] :start The resource
    #   from which to start the list. If not specified,
    #   then this resource will be used as the root.
    # @return [String] An `<ul>` containing the list.
    #--------------------------------------------------------
    def nav_toc_index( locals = {} )
      recurse = locals.key?(:recurse) && locals[:recurse]
      return if recurse && locals[:start].nil?

      commence = locals[:start] || current_page
      pages = commence.legitimate_children

      if recurse
        unless pages.to_a.empty?
          haml_tag :ul do
            pages.each do |p|
              haml_tag :li do
                haml_concat link_to p.data.title, p
                nav_toc_index :start => p, :recurse => true
              end
            end
          end
        end
      else
        capture_haml do
          locals[:klass] = locals.delete(:class) if locals.key?(:class)
          haml_tag :ul, :class => (locals.key?(:klass) && locals[:klass]) || nav_toc_index_class do
            haml_tag :li do
              haml_concat link_to commence.data.title, commence
              nav_toc_index :start => commence, :recurse => true
            end
          end
        end # capture_haml
      end

    end


    #########################################################
    # @!macro [new] class_helpers
    #    Both the built-in helpers and the partials (if you
    #    install them) use these helpers in order to access the
    #    configuration values. When writing your own partials
    #    it is generally unnecessary to use these helpers; you
    #    can simply assign your own class name.
    #
    #    The provided helpers and partials use CSS classes, and
    #    if the class names collide with your own class names
    #    or fail to meet with your naming standards, then they
    #    can be changed using the extension options.
    #########################################################


    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_breadcrumbs_class]`. 
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_breadcrumbs_class
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_class]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_breadcrumbs_alt_class]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_breadcrumbs_alt_class
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_alt_class]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_breadcrumbs_alt_label]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_breadcrumbs_alt_label
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_alt_label]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_brethren_class]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_brethren_class
      extensions[:MiddlemanPageGroups].options[:nav_brethren_class]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_brethren_index_class]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_brethren_index_class
      extensions[:MiddlemanPageGroups].options[:nav_brethren_index_class]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_legitimate_children_class]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_legitimate_children_class
      extensions[:MiddlemanPageGroups].options[:nav_legitimate_children_class]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_prev_next_class]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_prev_next_class
      extensions[:MiddlemanPageGroups].options[:nav_prev_next_class]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_prev_next_label_prev]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_prev_next_label_prev
      extensions[:MiddlemanPageGroups].options[:nav_prev_next_label_prev]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_prev_next_label_next]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_prev_next_label_next
      extensions[:MiddlemanPageGroups].options[:nav_prev_next_label_next]
    end

    #--------------------------------------------------------
    # Returns the value of the the extension option
    # `options[:nav_toc_index_class]`.
    #
    # @!macro class_helpers
    #
    # @return [String] Returns the name of the class.
    # @group CSS Class Helpers
    #--------------------------------------------------------
    def nav_toc_index_class
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_alt_class]
    end


  end #helpers

end # class MiddlemanPageGroups
