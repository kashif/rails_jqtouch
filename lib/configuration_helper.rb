module Jqtouch
  
  module ConfigurationHelper
    
    # Can generate the javascript to add jqtouch settings. 
    # +options+ is a Hash that is converted to json, and that specifies the options that are passed 
    # as argument to $(document).jQTouch.
    #
    # Example:
    #
    #   <%= jqtouch_init :status_bar => 'black-translucent' %>
    #
    # Generates the following code:
    #
    #   <script charset="utf-8" type="text/javascript">
    #   //<![CDATA[
    #   $(document).jQTouch({"statusBar": "black-translucent"});
    #   //]]>
    #   </script>
    def jqtouch_init(options={})
      javascript_tag "var jQT = new $.jQTouch(#{options.camelize_keys!(:lower).to_json});", :charset => "utf-8"
    end
  end
  
end
