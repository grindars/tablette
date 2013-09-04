module Tablette
  class Table < Element
    config.tag = 'table'
    config.render_nested_elements = %w(header! body footer!)
    config.allowed_configuration_options = %w(tag html_options)
    config.builtin_html_options = { :class => "tablette" }
    
    nest :header!, Header, :ivar_name => :header, :merge_children => true
    nest :body, Body
    nest :footer!, Footer, :ivar_name => :footer, :merge_children => true

    nest_through :body, :row, :column
    
    def initialize(*args, &block)
      @renderer = HTMLRenderer.new
      @helper = nil
      @header_builder = nil
      @cached_autoheader = nil
      
      super
    end

    def header(&block)
      header! do
        column(html_options: { colspan: 'auto'}, &block)
      end
    end

    def footer(&block)
      footer! do
        column(html_options: { colspan: 'auto'}, &block)
      end
    end

    def to_html(*args)
      columns = 0

      all_sections = [ self.header!, build_autoheader(args), self.body, self.footer! ].flatten!

      all_sections.each do |section|
        section_columns = section.columns_for_section args
        columns = section_columns if section_columns > columns
      end

      all_sections.each do |section|
        section.update_auto_colspan! columns, args
      end

      @sections_to_render = all_sections
      begin
        @renderer.to_html(super)
      ensure
        @sections_to_render = nil
      end
    end

    private

    def html_content(*args)
      buffer = ""

      @sections_to_render.each do |e|
        buffer << e.to_html(*args)
      end

      buffer
    end

    def build_autoheader(args)
      if !nonempty_table_section?(self.header!, args) && !@header_builder.nil?
        body = self.body

        auto_header = Header.new(inherited_config) do
          body.each do |body_section|
            body_section.row.each do |body_row|
              row do
                body_row.column.each do |body_column|
                  options = { :html_options => { :colspan => body_column.colspan(args) } }

                  builder_options, block = @header_builder.build body_column.key
                  options.merge! builder_options

                  column options, &block
                end
              end
            end
          end
        end

        [ auto_header ]
      else
        [ ]
      end
    end

    def nonempty_table_section?(section, args)
      section.any? do |entry|
        entry.row.any? do |row|
          row.column.any? do |column|
            column.colspan(args) != "auto"
          end
        end
      end
    end
  end
end
