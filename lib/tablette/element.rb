module Tablette
  class Element
    include ActiveSupport::Configurable

    attr_accessor :renderer, :helper
    
    def initialize(*args, &definition)
      options = args.extract_options!
      @renderer = options.delete(:renderer) { @renderer }
      @helper = options.delete(:helper) { @helper }
      @header_builder = options.delete(:header_builder) { @header_builder }
      
      instance_exec(&definition) if block_given?
      config.merge!(options)
    end

    def respond_to_missing?(method, include_private = false)
      super || @helper.respond_to?(method, include_private) || config.allowed_configuration_options.include?(method.to_s)
    end
  
    def method_missing(method, *args, &block)
      if @helper.respond_to? method
        @helper.send method, *args, &block
      elsif config.allowed_configuration_options.include?(method.to_s)
        # Catches a call to configuration option setter.
        #
        # Example:
        # body do
        #   html_options { class: 'test' } # Holds such calls
        # end
      
        config[method] = args.first || block
      
        class_eval do
          define_method method do |value|
            config[method] = value
          end
          protected method
        end
      
        config[method]
      else
        super
      end
    end
  end
end
