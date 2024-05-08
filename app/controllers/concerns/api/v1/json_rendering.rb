# frozen_string_literal: true

module Api
  module V1
    module JsonRendering
      private

      def render_json(object, serializer: serializer_class, **)
        render(json: object, **) and return if serializer.nil? || object.is_a?(Hash)

        is_collection = object.respond_to?(:each)

        render(json: serializer.new(object, is_collection:), **)
      end

      def render_record_errors(record)
        errors = record.errors.map do |error|
          { title: error.type, detail: error.message, attribute: error.attribute }
        end

        render_json({ errors: }, status: :unprocessable_entity)
      end

      def serializer_class
        nil
      end
    end
  end
end
