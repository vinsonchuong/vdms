module DataTypes
  module Text
    module FieldType
      def option_types
        {
          #'option1' => {:label_params => [:label, :option1], :description => 'This is option 1',
          #             :form_helper_params => [:text_field, :option1]}
        }
      end
    end

    module Field
      def label_params
        [:label, :data, field_type.name]
      end

      def description
        field_type.description
      end

      def form_helper_params
        [:text_field, :data]
      end
    end
  end
end
