# coding: utf-8
module Megatron
  class ErrorsController < ActionController::Base
    JSON_RESPONSES = {
      internal_server_error: "an unexpected error occurred",
      bad_request:           "bad request",
      forbidden:             "forbidden",
      method_not_allowed:    "method not supported",
      not_acceptable:        "not acceptable",
      not_found:             "not found",
      not_implemented:       "not implemented",
      unauthorized:          "unauthorized",
      unprocessable_entity:  "we couldn't process your input"
    }.freeze

    include Gaffe::Errors

    # Override 'error' layout
    layout 'megatron/errors'

    # Render the correct template based on the exception “standard” code.
    # Eg. For a 404 error, the `errors/not_found` template will be rendered.
    def show
      respond_to do |format|
        format.html {
          # Here, the `@exception` variable contains the original raised error
          render "megatron/errors/#{@rescue_response}", status: @status_code
        }
        format.json {
          render json: { errors: JSON_RESPONSES[@rescue_response] }, status: @status_code
        }
    end
  end
end
