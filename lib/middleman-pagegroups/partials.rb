################################################################################
# partials
#  Here's the deal: this is an extension and not an extension+template, so in
#  order to provide some modicum of usefulness to users, we're providing some
#  template-like helpers in the extension. This file constitutes the source
#  for them, with the added benefit that we can recycle the values in the
#  console application and generate real partial templates for users that
#  prefer pure MVC.
################################################################################


module MMPartials

  MM_BREADCRUMBS = <<HEREDOC
- pages = current_page.breadcrumbs
- unless pages.to_a.empty?
  %div{:class => (defined?(klass) && klass) || nav_breadcrumbs_class}
    %ul
      - pages.each do |p|
        %li= link_to p.data.title, p

-#
  - This partial renders links into an <ul>.
  - You probably need a class in order to render this properly.
  - :klass - pass in this local to specify a class for the containing div.
HEREDOC


  MM_BREADCRUMBS_ALT = <<HEREDOC
- pages = current_page.breadcrumbs
- unless pages.to_a.empty?
  %div{:class => (defined?(klass) && klass) || nav_breadcrumbs_alt_class}
    %ul
      - pages[0...pages.count-1].each do |p|
        %li= link_to p.data.title, p
      %li= (defined?(label) && label) || nav_breadcrumbs_alt_label

-#
  - This partial renders links into an <ul>.
  - You probably need a class in order to render this properly.
  - This alternate version replaces the last link with the extension's
    `nav_breadcrumbs_alt_label` value.
  - :label - pass in this local instead of using the default.
  - :klass - pass in this local to specify a class for the containing div.
HEREDOC


  MM_BRETHREN = <<HEREDOC
- commence = (defined?(start) && start) || current_page
- pages = commence.brethren
- unless pages.to_a.empty?
  %div{:class => (defined?(klass) && klass) || nav_brethren_class}
    %dl
      - pages.each do |p|
        %dt<
          = link_to p.data.title, p
        - if p.data.blurb
          %dd= p.data.blurb

-#
  - This partial renders links with blurbs into a <dl> to serve as
    a related links table of contents.
  - You probably need a class in order to render this properly.
  - For a compact form without blurbs, see also `_nav_brethren_index.haml.
  - :klass - pass in this local to specify a class for the containing div.
  - :start - pass in this local to specify a different starting point.
HEREDOC


  MM_BRETHREN_INDEX =<<HEREDOC
- commence = (defined?(start) && start) || current_page
- pages = commence.brethren
- unless pages.to_a.empty?
  %div{:class => (defined?(klass) && klass) || nav_brethren_index_class}
    %ul
      - pages.each do |p|
        %li= link_to p.data.title, p

-#
  This partial renders brethren into an <ul> to serve as a related-pages type
  of table of contents.
  - You probably need a class in order to render this properly.
  - :klass - pass in this local to specify a class for the containing div.
  - :start - pass in this local to specify a different starting point.
HEREDOC


  MM_LEGITIMATE_CHILDREN =<<HEREDOC
- commence = (defined?(start) && start) || current_page
- pages = commence.legitimate_children
- unless pages.to_a.empty?
  %div{:class => (defined?(klass) && klass) || nav_legitimate_children_class}
    %dl
      - pages.each do |p|
        %dt= link_to p.data.title, p
        - if p.data.blurb
          %dd= p.data.blurb

-#
  This partial renders links with blurbs into a <dl> to serve as a high-level
  table of contents.
  - You probably need a class in order to render this properly.
  - :klass - pass in this local to specify a class for the containing div.
  - :start - pass in this local to specify a different starting point.
HEREDOC


  MM_PREV_NEXT =<<HEREDOC
- p_prev = current_page.brethren_previous
- p_next = current_page.brethren_next
- b_prev = (defined?(label_previous) && label_previous) || nav_prev_next_label_prev
- b_next = (defined?(label_next) && label_next) || nav_prev_next_label_next
%div{:class => (defined?(klass) && klass) || nav_prev_next_class}
  - if p_prev.nil?
    %span= b_prev
  - else
    = link_to b_prev, p_prev
  - if p_next.nil?
    %span= b_next
  - else
    = link_to b_next, p_next

-#
  This partial renders a div with two spans that are suitable for use as
  previous and next buttons when properly styled.
  - You probably need a class in order to render this properly.
  - :klass          - pass in this local to specify a class for the containing div.
  - :label_previous - the label for the Previous button. Default is "Previous".
  - :label_next     - the label for the Next button. Default is "Next".
HEREDOC


  MM_TOC_INDEX = <<HEREDOC
- commence = (defined?(start) && start) || current_page
- pages = commence.legitimate_children
- if defined?(recurse) && recurse
  - unless pages.to_a.empty?
    %ul
      - pages.each do |p|
        %li<
          = link_to p.data.title, p
          = partial 'partials/toc_index', :locals => { :start => p, :recurse => true }
- else
  %ul{:class => (defined?(klass) && klass) || nav_toc_index_class}
    %li<
      = link_to commence.data.title, commence
      = partial 'partials/toc_index', :locals => { :start => commence, :recurse => true }

-#
  - This partial renders nested links into an <ul>. The top level item is the
    start page followed by the entire directory structure below it.
  - You probably need a class in order to render this properly.
  - :start - pass in this local to specify the starting page.
  - :klass - pass in this local to specify a class for the containing div.
HEREDOC


  #########################################################
  # MM_PARTIALS
  #  Used by the CLI application to build partial files.
  #########################################################
  MM_PARTIALS = [
      { :filename => '_nav_breadcrumbs.haml',         :content => MM_BREADCRUMBS         },
      { :filename => '_nav_breadcrumbs_alt.haml',     :content => MM_BREADCRUMBS_ALT     },
      { :filename => '_nav_brethren.haml',            :content => MM_BRETHREN            },
      { :filename => '_nav_brethren_index.haml',      :content => MM_BRETHREN_INDEX      },
      { :filename => '_nav_legitimate_children.haml', :content => MM_LEGITIMATE_CHILDREN },
      { :filename => '_nav_prev_next.haml',           :content => MM_PREV_NEXT           },
      { :filename => '_nav_toc_index.haml',           :content => MM_TOC_INDEX           },
  ]


end # module
