defmodule ChatApp.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :password_hash])
    |> validate_required([:username, :password])
    |> hash_password()
  end

  defp hash_password(cs) do
    password = get_field(cs, :password)
    if password do
      put_change(cs, :password_hash, Argon2.hash_pwd_salt(password))
    else
      cs
    end
  end
end
