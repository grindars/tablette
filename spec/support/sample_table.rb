require 'ostruct'

class ActiveRecordMock
  def self.human_attribute_name(name)
    "Humanized #{name.to_s}"
  end
end

def sample_collection
  [
    OpenStruct.new(id: 10, age: 27, value: 'Jim Morrison'),
    OpenStruct.new(id: 20, age: 70, value: 'William Blake'),
    OpenStruct.new(id: 30, age: 89, value: 'Robert Lee Frost')
  ]
end

def sample_helper_function(arg)
  "I hope this helps #{arg}"
end

def sample_formatter(key, member, index)
  "Formatter for #{member[key]}"
end

def sample_table_full_described_definition
  GridFu::Table.new do
    html_options class: 'table'

    header! do
      column 'Id', html_options: { colspan: 5 }
      column do
        'Doctor strangelove'
      end
    end

    body do
      html_options class: 'sortable'
      row do
        html_options do |member, index|
          { data: { id: member.id, index: index } }
        end

        column html_options: ->(member, _) { { data: { value: member.id } } } do |_, index|
          index
        end
        column :id
        column :age do |member, _|
          "Dead at #{member.age}"
        end
        column do |_, index|
          sample_helper_function(index)
        end
      end

      row html_options: { class: 'small' } do
        tag 'overriden_tr'

        column :test do
          "test"
        end

        column :age, formatter: :sample_formatter
      end
    end

    footer do
      "On foot"
    end
  end
end

def sample_table_full_described
  sample_table_full_described_definition.to_html(sample_collection)
end

def sample_table_short
  table = GridFu::Table.new do
    header do
      column 'Id'
      column 'Age'
    end

    column :id
    column :age
  end
  table.to_html(sample_collection)
end

def sample_table_active_record
  table = GridFu::Table.new do
    header! do
      column :id
      column :age
      column "Custom string"
      column do
        "Custom block"
      end
    end
    column :id
    column :age
  end
  table.to_html(sample_collection, ActiveRecordMock)
end