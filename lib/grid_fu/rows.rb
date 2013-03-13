module GridFu
  class Row < Element
    attr_reader :columns

    config.tag = 'tr'
    config.render_nested_elements = %w(column)

    def columns_for_row(args)
      columns = 0

      self.column.each do |column|
        colspan = column.colspan(args)

        if colspan.nil? || colspan == "auto"
          columns += 1
        else
          columns += colspan
        end
      end

      columns
    end

    def update_auto_colspan!(columns, args)
      auto_column = nil

      self.column.each do |column|
        next unless column.colspan(args) == "auto"

        if auto_column.nil?
          auto_column = column
        else
          raise "multiple columns with colspan=auto are defined"
        end
      end

      row_columns = columns_for_row(args)
      if auto_column.nil?
        if row_columns != columns
          raise "mismatched number of columns in table: #{columns} in table, #{row_columns} defined in row"
        end
      else
        auto_column.config[:html_options][:colspan] = columns - row_columns + 1
      end
    end
  end

  class BodyRow < Row
    config.override_html_options = proc { |member, index|
      { data: { id: member.try(:id) } }
    }

    nest :column, BodyColumn

    protected
    def html_content(member, index)
      html = column.map do |column|
        column.to_html(member, index)
      end
      html.join
    end
  end

  class HeaderRow < Row
    nest :column, HeaderColumn
  end

  class FooterRow < Row
    nest :column, FooterColumn
  end
end