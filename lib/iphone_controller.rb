module Jqtouch
  # Includes several macros and filters to facilitate work with drivers that need to process 
  # requests from an iPhone or iPod Touch (Mobile Safari browsers).
  #
  # The original code is taken from rails-iui (git://github.com/noelrappin/rails-iui.git) by
  # Noel Rappin.
  #  
  # Examples of use:
  #  
  # +acts_as_iphone_controller+ is available for inclusion in a specific driver or the
  # ApplicationController. The filter is automatically assigned +set_iphone_format+ that is 
  # responsible for allocating +request.format+ to format +:iphone+.
  #  
  #   class TareasController < ApplicationController
  #     acts_as_iphone_controller
  #     ...
  #   end
  #    
  # If you include +acts_as_iphone_controller(true)+, all requests are treated as coming from a
  # Mobile Safari browser, so +request.format+ will always be +:iphone+. Useful during 
  # development, testing and debugging
  module IphoneController
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
    
      def acts_as_iphone_controller(iphone_test_mode = false)
        @@iphone_test_mode = iphone_test_mode
        include IphoneController::InstanceMethods 
        iphone_test_mode ? before_filter(:force_iphone_format) : before_filter(:set_iphone_format)
        helper_method :is_iphone_request?
      end
      
      def iphone_test_mode?
        @@iphone_test_mode
      end
    end
    
    module InstanceMethods
      private
      
      # Force +request.format+ to +:iphone+
      def force_iphone_format
        request.format = :iphone
      end
      
      # Assign +request.format+ to +:iphone+ depending on whether the request came from a
      # Mobile Safari browser or a subdomain type iphone.dominio.com.
      #
      # For cases in which, from one of these devices, you want to see the original full website
      # assign the value +"desktop"+ to +cookies["browser"]+.
      def set_iphone_format
        if is_iphone_request? || is_iphone_format? || is_iphone_subdomain?
          request.format = cookies["browser"] == "desktop" ? :html : :iphone 
        end
      end
      
      # Returns +true+ if the +request.format+ is +:iphone+
      def is_iphone_format?
        request.format.to_sym == :iphone
      end
      
      # Verify that the User Agent is the one for Mobile Safari, which returns +true+.
      def is_iphone_request?
        request.user_agent =~ /(Mobile\/.+Safari)/
      end
      
      # Check that the subdomain is the type iphone.dominio.com.
      def is_iphone_subdomain?
        request.subdomains.first == "iphone"
      end
    end #InstanceMethods
  end #IphoneController
end #ActionController
