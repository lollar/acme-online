class ApplicationController < ActionController::Base
  rescue_from ::API::V1::UnprocessableEntity, with: :api_error_response
  rescue_from ::API::V1::BadRequest, with: :api_error_response

  # Rails strong params work great for rails forms but I think they are sufficiently
  # lacking when implementing an API. This overrides the params to a Hash. Rails is just
  # being rude by making me call "to_unsafe_h" :(
  def params
    super.to_unsafe_h.deep_symbolize_keys
  end

  private

  def api_error_response response
    render response.result
  end
end
