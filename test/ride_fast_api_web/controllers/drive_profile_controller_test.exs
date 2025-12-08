defmodule RideFastApiWeb.Drive_profileControllerTest do
  use RideFastApiWeb.ConnCase

  import RideFastApi.Driver_profilesFixtures

  @create_attrs %{license_number: "some license_number", license_expiry: ~D[2025-12-06], background_check_ok: true}
  @update_attrs %{license_number: "some updated license_number", license_expiry: ~D[2025-12-07], background_check_ok: false}
  @invalid_attrs %{license_number: nil, license_expiry: nil, background_check_ok: nil}

  describe "index" do
    test "lists all drive_profiles", %{conn: conn} do
      conn = get(conn, ~p"/drive_profiles")
      assert html_response(conn, 200) =~ "Listing Drive profiles"
    end
  end

  describe "new drive_profile" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/drive_profiles/new")
      assert html_response(conn, 200) =~ "New Drive profile"
    end
  end

  describe "create drive_profile" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/drive_profiles", drive_profile: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/drive_profiles/#{id}"

      conn = get(conn, ~p"/drive_profiles/#{id}")
      assert html_response(conn, 200) =~ "Drive profile #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/drive_profiles", drive_profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Drive profile"
    end
  end

  describe "edit drive_profile" do
    setup [:create_drive_profile]

    test "renders form for editing chosen drive_profile", %{conn: conn, drive_profile: drive_profile} do
      conn = get(conn, ~p"/drive_profiles/#{drive_profile}/edit")
      assert html_response(conn, 200) =~ "Edit Drive profile"
    end
  end

  describe "update drive_profile" do
    setup [:create_drive_profile]

    test "redirects when data is valid", %{conn: conn, drive_profile: drive_profile} do
      conn = put(conn, ~p"/drive_profiles/#{drive_profile}", drive_profile: @update_attrs)
      assert redirected_to(conn) == ~p"/drive_profiles/#{drive_profile}"

      conn = get(conn, ~p"/drive_profiles/#{drive_profile}")
      assert html_response(conn, 200) =~ "some updated license_number"
    end

    test "renders errors when data is invalid", %{conn: conn, drive_profile: drive_profile} do
      conn = put(conn, ~p"/drive_profiles/#{drive_profile}", drive_profile: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Drive profile"
    end
  end

  describe "delete drive_profile" do
    setup [:create_drive_profile]

    test "deletes chosen drive_profile", %{conn: conn, drive_profile: drive_profile} do
      conn = delete(conn, ~p"/drive_profiles/#{drive_profile}")
      assert redirected_to(conn) == ~p"/drive_profiles"

      assert_error_sent 404, fn ->
        get(conn, ~p"/drive_profiles/#{drive_profile}")
      end
    end
  end

  defp create_drive_profile(_) do
    drive_profile = drive_profile_fixture()

    %{drive_profile: drive_profile}
  end
end
