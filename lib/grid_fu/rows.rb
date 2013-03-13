module GridFu
  class Row < Element
    attr_reader :columns

    config.tag = 'tr'
    config.render_nested_elements = %w(column)
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