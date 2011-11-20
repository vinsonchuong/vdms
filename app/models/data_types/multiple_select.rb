module DataTypes
  module MultipleSelect
    module FieldType
      def option_types
        {
          'selection_items' => {:label_params => [:label, :selection_items, 'Selection Items'],
                                :description => 'Enter one item per line',
                                :form_helper_params => [:text_area, :selection_items, :size => '20x10',
                                :value => options['selection_items']]}
        }
      end
    end

    module Field
      def form_helper_params
        items = field_type.options['selection_items'].lines.to_a.map(&:chomp)
        {
          :type => :single,
          :args => [:select, :data, items, {}, :multiple => true, :size => 8]
        }
      end
    end
  end
end
