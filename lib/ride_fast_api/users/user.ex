defmodule RideFastApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :email, :phone]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :rides, RideFastApi.Rides.Ride

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :phone, :password])
    |> validate_required([:name, :email, :phone, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "deve ser um email válido")
    |> unsafe_validate_unique([:email], RideFastApi.Repo, message: "já está em uso")
    |> put_password_hash()
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :phone, :password])
    |> validate_required([:name, :email, :phone])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "deve ser um email válido")
    |> unsafe_validate_unique([:email], RideFastApi.Repo, message: "já está em uso")
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
