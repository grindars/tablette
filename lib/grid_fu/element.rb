module GridFu
  class Element
    include ActiveSupport::Configurable

    attr_accessor :renderer
    
    def initialize(*args, &definition)
      options = args.extract_options!
      if options.include? :renderer
        @renderer = options.delete :renderer
      end
      
      instance_exec(&definition) if block_given?
      config.merge!(options)
    end
  end
end