defmodule RideFastApi.Drivers.Driver do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :email, :phone, :status]}
  schema "drivers" do
    field :name, :string
    field :email, :string
    field :phone, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :status, :string

    has_one :drive_profile, RideFastApi.Driver_profiles.Drive_profile
    has_many :vehicles, RideFastApi.Vehicles.Vehicle
    has_many :rides, RideFastApi.Rides.Ride
    many_to_many :lenguages, RideFastApi.Languages.Lenguage, join_through: "drivers_lenguages"

    timestamps(type: :utc_datetime)
  end

  def changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :email, :phone, :password, :status])
    |> validate_required([:name, :email, :phone, :password, :status])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "deve ser um email válido")
    |> unsafe_validate_unique([:email], RideFastApi.Repo, message: "já está em uso")
    |> put_password_hash()
  end

  def update_changeset(driver, attrs) do
    driver
    |> cast(attrs, [:name, :email, :phone, :password, :status])
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
