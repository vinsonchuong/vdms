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
    end
  end
end
