require 'spec_helper'

describe 'Configuration' do
  subject { sample_table_full_described_html }

  it 'should correct render sample table defined fully' do
    subject.should have_tag 'table', with: { class: 'table' }, count: 1 do
      #with_tag 'thead'
      with_tag 'tbody', with: { class: 'sortable' }, count: 1 do
        sample_collection.each_with_index do |member, index|
          with_tag "tr[data-id='#{member.id}'][data-index='#{index}']" do
            with_tag 'td', with: { 'data-value' => member.id }, text: index, count: 1
            with_tag 'td', text: member.id, count: 1
            with_tag 'td', text: "Dead at #{member.age}", count: 1
            with_tag 'td', text: 'I hope this helps', count: 1
          end
        end
      end
      #with_tag 'tfoot'
    end
  end
end