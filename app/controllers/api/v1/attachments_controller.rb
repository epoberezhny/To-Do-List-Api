# frozen_string_literal: true

module Api
  module V1
    class AttachmentsController < Api::V1::ApplicationController
      def upload
        set_rack_response(AttachmentUploader.upload_response(:cache, request.env))
      end

      private

      def set_rack_response((status, headers, body))
        self.status = status
        self.headers.merge!(headers)
        self.response_body = body
      end
    end
  end
end
