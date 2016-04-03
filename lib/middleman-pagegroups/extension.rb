################################################################################
# extension.rb
#  This file constitutes the framework for the bulk of this extension.
################################################################################
require 'middleman-core'
require 'middleman-pagegroups/partials'

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


  ############################################################
  #  Sitemap manipulators.
  #    Add new methods to each resource.
  ############################################################
  def manipulate_resource_list(resources)

    resources.each do |resource|

      #--------------------------------------------------------
      # page_name
      #    Make page_name available for each page. This is the
      #    file base name after any renaming has occurred.
      #    Useful for assigning classes, etc.
      #--------------------------------------------------------
      def resource.page_name
        File.basename( self.destination_path, '.*' )
      end


      #--------------------------------------------------------
      #  page_group
      #    Make page_group available for each page. This is
      #    the source parent directory (not the request path).
      #    Useful for for assigning classes, and/or group
      #    conditionals.
      #--------------------------------------------------------
      def resource.page_group
        File.basename( File.split( self.source_file )[0] )
      end


      #--------------------------------------------------------
      #  group_count
      #    Returns the quantity of pages in the current
      #    page’s group. This is NOT the count of the number
      #    of an index page's legitimate children.
      #--------------------------------------------------------
      def resource.group_count
        self.brethren.count + 1
      end


      #--------------------------------------------------------
      #  sort_order
      #    Returns the page sort order or 0. This is set
      #    initial population of the resource map, and made
      #    available here.
      #--------------------------------------------------------
      def resource.sort_order
        options[:sort_order]
      end


      #--------------------------------------------------------
      #  page_sequence
      #    Returns the page sequence amongst all of the
      #    brethren. Can be uses as a page number surrogate.
      #    Base 1.
      #--------------------------------------------------------
      def resource.page_sequence
        if self.sort_order == 0
          return nil
        else
          self.siblings
            .find_all { |p| p.sort_order != 0 && !p.ignored }
            .push(self)
            .sort_by { |p| p.sort_order }
            .find_index(self) + 1
        end
      end


      #--------------------------------------------------------
      #  brethren
      #    Returns an array of all of the siblings of the
      #    specified page, taking into account their
      #    eligibility for display.
      #      - is not already the current page.
      #      - has a sort_order.
      #      - is not ignored.
      #    Returned array will be:
      #      - sorted by sort_order.
      #--------------------------------------------------------
      def resource.brethren
        self.siblings
          .find_all { |p| p.sort_order != 0 && !p.ignored && p != self }
          .sort_by { |p| p.sort_order }
      end


      #--------------------------------------------------------
      #  brethren_next
      #    Returns the next sibling based on order or nil.
      #--------------------------------------------------------
      def resource.brethren_next
        if self.sort_order == 0
          return nil
        else
          return self.brethren.find { |p| p.sort_order > self.sort_order }
        end
      end


      #--------------------------------------------------------
      #  brethren_previous
      #    Returns the previous sibling based on order or nil.
      #--------------------------------------------------------
      def resource.brethren_previous
        if self.sort_order == 0
          return nil
        else
          return self.brethren.reverse.find { |p| p.sort_order < self.sort_order }
        end
      end


      #--------------------------------------------------------
      #  navigator_eligible?
      #    Determine whether a page is eligible to include a
      #    previous/next page control based on:
      #      - the group is set to allow navigation (:navigate)
      #      - this page is not excluded from navigation. (:navigator => false)
      #      - this page has a sort_order.
      #--------------------------------------------------------
      def resource.navigator_eligible?
        group_navigates = self.parent && self.parent.data['navigate'] == true
        self_navigates = !( self.data.key?('navigator') && self.data['navigator'] == false )

        group_navigates && self_navigates && self.sort_order != 0
      end


      #--------------------------------------------------------
      #  legitimate_children
      #    Returns an array of all of the children of the
      #    specified page, taking into account their
      #    eligibility for display.
      #      - has a sort_order.
      #      - is not ignored.
      #    Returned array will be:
      #      - sorted by sort_order.
      #--------------------------------------------------------
      def resource.legitimate_children
        self.children
          .find_all { |p| p.sort_order !=0 && !p.ignored }
          .sort_by { |p| p.sort_order }
      end


      #--------------------------------------------------------
      #  breadcrumbs
      #    Returns an array of pages leading to the current
      #    page.
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
      if resource.content_type && resource.content_type.start_with?('text/html', 'application/xhtml')
        page_name = File.basename( resource.path, '.*' )
        if resource.data.key?('order')
          sort_order = resource.data['order']
        elsif ( match = /^(\d*?)_/.match(page_name) )
          sort_order = match[1]
          if @app.extensions[:MiddlemanPageGroups].options[:strip_file_prefixes]
            path_part = File.dirname( resource.destination_path )
            name_part = page_name.sub( "#{sort_order}_", '') + File.extname( resource.path )
            resource.destination_path = File.join( path_part, name_part )
          end
        else
          sort_order = nil
        end

        resource.options[:sort_order] = sort_order.to_i
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
    # page_classes
    #   Extend the built-in page_classes to include the
    #   naked group and page name.
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
    # nav_breadcrumbs( locals )
    #   Generate the breadcrumbs partial.
    #   locals:
    #     [:klass] == class name for the list's <div>
    #--------------------------------------------------------
    def nav_breadcrumbs( locals = {} )
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BREADCRUMBS).render(self, locals)
    end


    #--------------------------------------------------------
    # nav_breadcrumbs_alt( locals )
    #   Generate the breadcrumbs partial, alternate form.
    #   locals:
    #     [:klass] == class name for the list's <div>
    #     [:label] == label for "Current page"
    #--------------------------------------------------------
    def nav_breadcrumbs_alt( locals = {} )
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BREADCRUMBS_ALT).render(self, locals)
    end

    #--------------------------------------------------------
    # nav_brethren( locals )
    #   Generate a fuller list of related topics, including
    #   blurbs if present.
    #   locals:
    #     [:klass] == class name for the list's <div>
    #     [:start] == resource from which to start the list.
    #--------------------------------------------------------
    def nav_brethren( locals = {} )
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BRETHREN).render(self, locals)
    end


    #--------------------------------------------------------
    # nav_brethren_index( locals )
    #   Generates a condensed list of brethren, omitting
    #   blurbs.
    #   locals:
    #     [:klass]          == class name for the list's <div>
    #     [:start] == resource from which to start the list.
    #--------------------------------------------------------
    def nav_brethren_index(locals = {})
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_BRETHREN_INDEX).render(self, locals)
    end


    #--------------------------------------------------------
    # nav_legitimate_children( locals )
    #   Generate a list of legitimate children.
    #   locals:
    #     [:klass] == class name for the list's <div>
    #     [:start] == resource from which to start the list.
    #--------------------------------------------------------
    def nav_legitimate_children(locals = {})
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_LEGITIMATE_CHILDREN).render(self, locals)
    end


    #--------------------------------------------------------
    # nav_prev_next( locals )
    #   Generate a previous and next button.
    #   locals:
    #     [:klass]          == class name for the list's <div>
    #     [:label_previous] == label for previous button
    #     [:label_next]     == label for next button
    #--------------------------------------------------------
    def nav_prev_next(locals = {})
      locals[:klass] = locals.delete(:class) if locals.key?(:class)
      Haml::Engine.new(MMPartials::MM_PREV_NEXT).render(self, locals)
    end


    #--------------------------------------------------------
    # nav_toc_index( locals )
    #   Generate a nested table of contents.
    #   locals:
    #     [:start] == top-level starting resource.
    #     [:klass] == class name for the list's <div>
    #   Note in this case we're going to not use the haml
    #   template because render won't support the recursion
    #   we need.
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
    # expose selected defaults
    #   We want our templates to be able to access the
    #   extension options for default settings in partials.
    #########################################################

    def nav_breadcrumbs_class
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_class]
    end

    def nav_breadcrumbs_alt_class
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_alt_class]
    end

    def nav_breadcrumbs_alt_label
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_alt_label]
    end

    def nav_brethren_class
      extensions[:MiddlemanPageGroups].options[:nav_brethren_class]
    end

    def nav_brethren_index_class
      extensions[:MiddlemanPageGroups].options[:nav_brethren_index_class]
    end

    def nav_legitimate_children_class
      extensions[:MiddlemanPageGroups].options[:nav_legitimate_children_class]
    end

    def nav_prev_next_class
      extensions[:MiddlemanPageGroups].options[:nav_prev_next_class]
    end

    def nav_prev_next_label_prev
      extensions[:MiddlemanPageGroups].options[:nav_prev_next_label_prev]
    end

    def nav_prev_next_label_next
      extensions[:MiddlemanPageGroups].options[:nav_prev_next_label_next]
    end

    def nav_toc_index_class
      extensions[:MiddlemanPageGroups].options[:nav_breadcrumbs_alt_class]
    end


  end #helpers


end # class MiddlemanPageGroups
