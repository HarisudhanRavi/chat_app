defmodule ChatAppWeb.Plugs.GuardianAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :chat_app,
    error_handler: ChatAppWeb.Plugs.AuthErrorHandler,
    module: ChatApp.Guardian

    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource, ensure: true

end
