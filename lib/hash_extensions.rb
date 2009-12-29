module Jqtouch
  
  module HashExtensions
    # Destructively camelize all keys.
    # By default, converts the keys of the form UpperCamelCase. If the argument +first_letter+ is
    # assigned to :lower, the keys generated are of the form lowerCamelCase.
    def camelize_keys!(first_letter = :upper)
      keys.each {|k| self[k.to_s.camelize(first_letter)] = delete(k) }
      self
    end
  end
end

Hash.send(:include, Jqtouch::HashExtensions)
