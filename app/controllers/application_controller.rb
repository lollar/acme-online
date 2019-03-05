class ApplicationController < ActionController::Base
  protected

  # Rails strong params work great for rails forms but I think they are sufficiently
  # lacking when implementing an API. This overrides the params to a Hash. Rails is just
  # being rude by making me call "to_unsafe_h" :(
  def params
    super.to_unsafe_h.deep_symbolize_keys
  end
end
