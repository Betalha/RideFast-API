defmodule RideFastApi.Driver_profilesTest do
  use RideFastApi.DataCase

  alias RideFastApi.Driver_profiles

  describe "drive_profiles" do
    alias RideFastApi.Driver_profiles.Drive_profile

    import RideFastApi.Driver_profilesFixtures

    @invalid_attrs %{license_number: nil, license_expiry: nil, background_check_ok: nil}

    test "list_drive_profiles/0 returns all drive_profiles" do
      drive_profile = drive_profile_fixture()
      assert Driver_profiles.list_drive_profiles() == [drive_profile]
    end

    test "get_drive_profile!/1 returns the drive_profile with given id" do
      drive_profile = drive_profile_fixture()
      assert Driver_profiles.get_drive_profile!(drive_profile.id) == drive_profile
    end

    test "create_drive_profile/1 with valid data creates a drive_profile" do
      valid_attrs = %{license_number: "some license_number", license_expiry: ~D[2025-12-06], background_check_ok: true}

      assert {:ok, %Drive_profile{} = drive_profile} = Driver_profiles.create_drive_profile(valid_attrs)
      assert drive_profile.license_number == "some license_number"
      assert drive_profile.license_expiry == ~D[2025-12-06]
      assert drive_profile.background_check_ok == true
    end

    test "create_drive_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Driver_profiles.create_drive_profile(@invalid_attrs)
    end

    test "update_drive_profile/2 with valid data updates the drive_profile" do
      drive_profile = drive_profile_fixture()
      update_attrs = %{license_number: "some updated license_number", license_expiry: ~D[2025-12-07], background_check_ok: false}

      assert {:ok, %Drive_profile{} = drive_profile} = Driver_profiles.update_drive_profile(drive_profile, update_attrs)
      assert drive_profile.license_number == "some updated license_number"
      assert drive_profile.license_expiry == ~D[2025-12-07]
      assert drive_profile.background_check_ok == false
    end

    test "update_drive_profile/2 with invalid data returns error changeset" do
      drive_profile = drive_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Driver_profiles.update_drive_profile(drive_profile, @invalid_attrs)
      assert drive_profile == Driver_profiles.get_drive_profile!(drive_profile.id)
    end

    test "delete_drive_profile/1 deletes the drive_profile" do
      drive_profile = drive_profile_fixture()
      assert {:ok, %Drive_profile{}} = Driver_profiles.delete_drive_profile(drive_profile)
      assert_raise Ecto.NoResultsError, fn -> Driver_profiles.get_drive_profile!(drive_profile.id) end
    end

    test "change_drive_profile/1 returns a drive_profile changeset" do
      drive_profile = drive_profile_fixture()
      assert %Ecto.Changeset{} = Driver_profiles.change_drive_profile(drive_profile)
    end
  end
end
