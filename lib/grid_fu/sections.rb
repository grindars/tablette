module GridFu
  class Section < Element
    config.render_nested_elements = %w(row)

    def columns_for_section(args)
      columns = 0

      self.row.each do |row|
        row_columns = row.columns_for_row args
        columns = row_columns if row_columns > columns
      end

      columns
    end

    def update_auto_colspan!(columns, args)
      self.row.each do |row|
        row.update_auto_colspan! columns, args
      end
    end
  end

  class Body < Section
    config.tag = 'tbody'

    nest :row, BodyRow
    nest_through :row, :column

    def columns_for_section(args)
      collection, resource_class = args
      return 0 if collection.empty?

      super([collection.first, 0])
    end

    def update_auto_colspan!(columns, args)

    end

    protected
    def html_content(collection, resource_class = nil)
      collection.map.with_index do |member, index|
        row.map { |row| row.to_html(member, index) }
      end
    end
  end

  class Header < Section
    config.tag = 'thead'

    nest :row, HeaderRow
    nest_through :row, :column

    def merge_with!(header)
      self.row.concat header.row
    end
  end

  class Footer < Section
    config.tag = 'tfoot'

    nest :row, FooterRow
    nest_through :row, :column

    def merge_with!(footer)
      self.row.concat footer.row
    end
  end
end
