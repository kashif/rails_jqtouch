require "rails_jqtouch_mixin.rb"

module Jqtouch
  
  include RailsJQTouchMixin
  # Helpers to generate the various elements that make up the view to the responses of the 
  # Mobile Safari browser, according to the styles and markup specified in jQTouch.
  #
  # Within conunto of items that can generate are:
  # * page
  # * pad
  # * panel
  # * fieldset
  # * row
  # * toolbar
  # * button
  # * list
  # * TODO: grouped list
  #
  # Example (excerpt from the example of jQTouch index.html):
  #
  #   <% jqt_page 'home', :selected => true do  %>
  #   <% jqt_toolbar 'jQTouch' do %>
  #     <%= mobile_button_to "About", '#about', :effect => 'slideup' %>
  #   <% end %>
  # 
  #   <%= mobile_list [
  #       {:name => "Features", :url => "#features"},
  #       {:name => "Demos", :url => "#demos"},
  #       {:name => "Docs", :url => "docs.html"},
  #       {:name => "License", :url => "#license"},
  #       {:name => "Download &raquo;", :url => "http://www.jqtouch.com/", :target => "_self"} ]  %>
  #
  #   <% end %>
  #
  #   <% mobile_panel 'about' do %>
  #     <% mobile_pad :style => 'padding-top: 80px' do %>
  #       <p>jQTouch was created by David Kaneda as a means of easily creating iPhone-styled websites. 
  #       It is released open source, under the MIT license. It is still in its early stages of development 
  #       and is currently lacking in documentation. 
  #       For more information about jQTouch, please contact 
  #       <a href="http://twitter.com/davidkaneda/">David on Twitter, @davidkaneda.</a></p>
  #    
  #       <%= mobile_back_button 'Close', :class => "grayButton"  %>
  #     <% end %> 
  #   <% end %>
  module MobileHelper
    
    # Generate the wrapper for a page, referenced by an id. Example of use:
    #
    #   mobile_page("home", :selected => true) do
    #     content_tag(:h1, "Home Page")
    #   end
    #
    # Genera:
    #
    #   <div id="home" selected="true">
    #     <h1>Home Page</h1>
    #   </div>
    def jqt_page(id, options = {}, &proc)
      raise "Proc needed" unless block_given?
      concat build_page(id, options, &proc)
    end
    
    # Generates a +div+ with the class *pad*, which serves as a container for form elements, text, 
    # among others. You can specify html options in + options +. If you specify +:class+ within 
    # the options, this is added to "pad". Example:
    #
    #   mobile_pad(:class => "pointless_class") do
    #     content_tag(:h1, "Home Page")
    #   end
    #
    # Which generates:
    #
    #   <div class="pad pointless_class">
    #     <h1>Home Page</h1>
    #   </div>
    def mobile_pad(options = {}, &proc)
      raise "Proc needed" unless block_given?
      options[:class] = options.has_key?(:class) ? "pad #{options[:class]}" : "pad"
      concat content_tag(:div, capture(&proc), options)
    end
    
    # It's like +mobile_page+, but adds the resulting div class +panel+. Example
    #
    #   mobile_panel("home", :class => "pointless_class") do
    #     content_tag(:h1, "Home Page")
    #   end
    #
    # Which generates:
    #
    #   <div class="panel pad pointless_class" id="home">
    #     <h1>Home Page</h1>
    #   </div>
    def mobile_panel(id, options = {}, &proc)
      options[:class] = options.has_key?(:class) ? "panel #{options[:class]}" : "panel"
      mobile_page id, options, &proc
    end
    
    # Generates a +fieldset+, which serves as a container for form elements (in practice contain 
    # several +mobile_row+). You can specify html options in + options +. Example:
    #
    #   mobile_fieldset(:class => "pointless_class") do
    #     content_tag(:span, "Field")
    #   end
    #
    # Which generates:
    #
    #   <fieldset class="pointless_class">
    #     <span>Field</span>
    #   </fieldset>
    def mobile_fieldset(options = {}, &proc)
      raise "Proc needed" unless block_given?
      concat content_tag(:fieldset, capture(&proc), options)
    end
  
    # Generates a + div + with + row + class that serves as a container for form elements.
    #  +name+ label specifies the form field. You can specify html options in + options +. Example:
    #
    #   mobile_row("Name", :class => "pointless_class") do
    #     content_tag(:span, "Dummy Field")
    #   end
    #
    # Which generates:
    #
    #   <div class="row pointless_class">
    #     <label>Field</label>
    #     <span>Dummy Field</span>
    #   </div>
    #
    # It can also be used without block: Example:
    #
    #   mobile_row "Name"
    #
    # Generates the following HTML:
    #
    #   <div class="row">
    #     <label>Field</label>
    #   </div>
    def mobile_row(name=nil, options = {}, &proc)
      options[:class] = options.has_key?(:class) ? "row #{options[:class]}" : "row"
      label = name ? content_tag(:label, name) : ""
      if block_given?
        concat content_tag(:div, label + capture(&proc), options)
      else
        content_tag(:div, label, options)
      end
    end
    
    # Generates the toolbar (toolbar), with the title specified by + title +, and content through a block. 
    # + options + for now accepts option +: back_button +, which lets you add a button 
    # to go back (Back Button) with the specified name. Example:
    #
    #   mobile_toolbar("Home", :back_button => "Volver") do
    #     content_tag(:h2, "Sweet Home")
    #   end
    #
    # Generates the following HTML:
    #
    #   <div class="toolbar">
    #     <h1>Home</h1>
    #     <h2>Sweet Home</h2>
    #     <a href="#" class="button back">Volver</a>
    #   </div>
    def jqt_toolbar(title, options={}, &proc)
      raise "Proc needed" unless block_given?
      concat build_toolbar(title, options, &proc)
    end
    
    # Generates a page (type +mobile_page+), with a +mobile_toolbar+ automatically. 
    # The title on the toolbar specified by + title +, and the id of the page 
    # (by default, if not specified +: id + in + options +) is + title + in the form
    # * underscore * (spaces and + title + are replaced by also underscore).
    #
    # Example:
    #
    #   mobile_page_with_toolbar("JQ Touch", :selected => true, :back_button => "Volver") do
    #     content_tag(:h2, "Sweet Home")
    #   end
    #
    # Generates:
    #
    #   <div id="jq_touch" selected="true">
    #     <div class="toolbar">
    #       <h1>JQ Touch</h1>
    #       <a href="#" class="button back">Volver</a>
    #     </div>
    #     <h2>Sweet Home</h2>
    #   </div>
    def mobile_page_with_toolbar(title, options={}, &proc)
      raise "Proc needed" unless block_given?
      id = options.delete(:id) || title.gsub(" ", "_").underscore
      toolbar = build_toolbar(title, options)
      concat build_page(id, options, toolbar, &proc)
    end
    
    # Generates a button (link to class * button *), which contains additional class * back *.
    # Example:
    #
    #   mobile_back_button "Volver" 
    #   
    # Generates:
    #
    # <a href="#" class="button back">Volver</a>
    def jqt_back_button(name, html_options = {})
      html_options[:class] = html_options.has_key?(:class) ? "back #{html_options[:class]}" : "back"
      jqt_button_to(name, "#", html_options)
    end
    
    def jqt_home_back_button(name, html_options = {})
      html_options[:class] = html_options.has_key?(:class) ? "back #{html_options[:class]}" : "back"
      jqt_button_to(name, "#Home", html_options)
    end
    
    # Generates a button (link to class * button *) identified by the name +name+.
    # +options+ and +html_options+ will behave the same as +link_to+. 
    # The transition effect may be indicated by +:effect+ in +html_options+.
    #
    # Example:
    #
    #   mobile_button_to("About", "#about", :class => "leftButton", :effect => "flip")
    #
    # Generates:
    #
    #   <a href="#about" class="button leftButton flip">About</a>
    def jqt_button_to(name, options, html_options={})    
      html_options[:class] = ["button",
                              html_options.delete(:class), 
                              html_options.delete(:effect)].compact.join(" ")
      link_to(name, options, html_options)
    end
    
    # Generates an item from a list (li). +item+ is a Hash that contains 
    # at least the keys +name+ and +:url+. Additionally you can specify +:target+.
    #
    #   mobile_list_item :name => "Test Item", :url => "#test_item"
    #
    # Generates:
    #
    #   <li><a href="#test_item">Test Item</a></li>
    def jqt_list_item(item, options = {})
      raise "Hash with keys :name and :url needed" unless item.has_key?(:name) && item.has_key?(:url)
      effect = options.delete(:effect) || nil
      options[:class] = effect if effect 
      options[:target] = item[:target] if item.has_key?(:target)
      if options[:rel]
        none = 1
      elsif item[:url][0..3] == 'http'
        options[:rel] = "external"
      else
        options[:rel] = nil
      end
      list_text = ''
      list_text << link_to(item[:name], item[:url], options)
      list_text << link_to(item[:subhead].untaint, item[:url], options) if item[:subhead]
      if item.has_key?(:image_filename)
        list_text = link_to("<img src=\"#{item[:image_filename]}\" class=\"sp-list-image\"> #{item[:name]}", item[:url])
        image_class = "image-list-item"
      end
      content_tag(:li, list_text, :class => 'arrow')
    end
    
    # Generate a list (ul) with +edgetoedge+ class, the elements of the list items are specified by +items????+, 
    # which cumnplen as specified for the attribute +item+ to +mobile_list_item+. 
    # +options+ to specify options to the links generated +mobile_list_item+.
    #
    #
    # Example:
    #
    #   items = [
    #     {:name => "Test Item", :url => "#test_item"},
    #     {:name => "Test Item 2", :url => "#test_item2", :target => "_self"}]
    #
    #   mobile_list(items, :effect => "flip")
    #
    # Generates:
    #
    #   <ul class="edgetoedge">
    #     <li><a href="#test_item" class="flip">Test Item</a></li>
    #     <li><a href="#test_item2" class="flip" target="_self">Test Item 2</a></li>
    #   </ul>
    def jqt_list(items, options = {})
      list_class = options[:list_class] || "rounded"
      items.map! {|i| jqt_list_item(i, options) }
      content_tag(:ul, items.join, :class => list_class)
    end
    
    private
    
    def build_toolbar(title, options = {}, &proc)
      proc = block_given? ? capture(&proc) : ""
      back = options.delete(:back_button)
      home = options.delete(:home_button)
      right = options.delete(:right_button)
      html = back ? jqt_back_button(back) : ""
      html = jqt_home_back_button(home) if home
      html = html << jqt_button_to(right[:name], right[:link] ) if right
      
      
      content_tag :div, 
        content_tag(:h1, title) + proc + html,
        :class => 'toolbar'
    end
    
    def build_page(id, options = {}, prebody_html = "", &proc)
      proc = block_given? ? capture(&proc) : ""
      options.merge!(:id => "#{id}")
      options.merge!(:class => "current") if options.delete(:selected) == true
      unless options[:tab_bar] == false
        prebody_html = iphone_tabbar(id) + prebody_html
      end
      content_tag(:div, prebody_html + proc, options)
    end
    
  end
end
