# frozen_string_literal: true

module Api
  module V1
    module JsonRendering
      private

      def render_json(object, **options)
        render(json: object, **default_render_options.merge(options))
      end

      def default_render_options
        {}
      end
    end
  end
end
