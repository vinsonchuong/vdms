module DataTypes
  module SingleSelect
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
        {
          :type => :single,
          :args => [:select, :data, field_type.options['selection_items'].lines.to_a.map(&:chomp)]
        }
      end
    end
  end
end
