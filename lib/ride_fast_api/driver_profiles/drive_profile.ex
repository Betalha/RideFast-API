defmodule RideFastApi.Driver_profiles.Drive_profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "drive_profiles" do
    field :license_number, :string
    field :license_expiry, :date
    field :background_check_ok, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(drive_profile, attrs) do
    drive_profile
    |> cast(attrs, [:license_number, :license_expiry, :background_check_ok])
    |> validate_required([:license_number, :license_expiry, :background_check_ok])
  end
end
