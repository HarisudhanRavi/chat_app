defmodule ChatApp.Guardian do
  use Guardian, otp_app: :chat_app
  alias ChatApp.Account

  def subject_for_token(user, _claims) do
    {:ok, user.id}
  end

  def resource_from_claims(%{"sub" => id}) do
    {
      :ok,
      Account.get_user!(id)
    }
  end

  def resource_from_claims(_), do: {:error, :resource_not_found}

end
