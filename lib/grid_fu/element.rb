module GridFu
  class Element
    include ActiveSupport::Configurable

    attr_accessor :renderer, :helper
    
    def initialize(*args, &definition)
      options = args.extract_options!
      if options.include? :renderer
        @renderer = options.delete :renderer
      end
      
      if options.include? :helper
        @helper = options.delete :helper
      end
      
      instance_exec(&definition) if block_given?
      config.merge!(options)
    end

    def respond_to?(method)
      super || @helper.respond_to?(method) || config.allowed_configuration_options.include?(method.to_s)
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
