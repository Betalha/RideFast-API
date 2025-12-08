defmodule RideFastApiWeb.RideControllerTest do
  use RideFastApiWeb.ConnCase

  import RideFastApi.RidesFixtures

  @create_attrs %{status: "some status", started_at: ~N[2025-12-06 23:51:00], driver_id: 42, user_id: 42, vehicle_id: 42, origen_lat: "120.5", origen_lng: "120.5", price_estimate: "120.5", final_price: "120.5", request_at: ~N[2025-12-06 23:51:00], endend_at: ~N[2025-12-06 23:51:00]}
  @update_attrs %{status: "some updated status", started_at: ~N[2025-12-07 23:51:00], driver_id: 43, user_id: 43, vehicle_id: 43, origen_lat: "456.7", origen_lng: "456.7", price_estimate: "456.7", final_price: "456.7", request_at: ~N[2025-12-07 23:51:00], endend_at: ~N[2025-12-07 23:51:00]}
  @invalid_attrs %{status: nil, started_at: nil, driver_id: nil, user_id: nil, vehicle_id: nil, origen_lat: nil, origen_lng: nil, price_estimate: nil, final_price: nil, request_at: nil, endend_at: nil}

  describe "index" do
    test "lists all rides", %{conn: conn} do
      conn = get(conn, ~p"/rides")
      assert html_response(conn, 200) =~ "Listing Rides"
    end
  end

  describe "new ride" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/rides/new")
      assert html_response(conn, 200) =~ "New Ride"
    end
  end

  describe "create ride" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/rides", ride: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/rides/#{id}"

      conn = get(conn, ~p"/rides/#{id}")
      assert html_response(conn, 200) =~ "Ride #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/rides", ride: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ride"
    end
  end

  describe "edit ride" do
    setup [:create_ride]

    test "renders form for editing chosen ride", %{conn: conn, ride: ride} do
      conn = get(conn, ~p"/rides/#{ride}/edit")
      assert html_response(conn, 200) =~ "Edit Ride"
    end
  end

  describe "update ride" do
    setup [:create_ride]

    test "redirects when data is valid", %{conn: conn, ride: ride} do
      conn = put(conn, ~p"/rides/#{ride}", ride: @update_attrs)
      assert redirected_to(conn) == ~p"/rides/#{ride}"

      conn = get(conn, ~p"/rides/#{ride}")
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, ride: ride} do
      conn = put(conn, ~p"/rides/#{ride}", ride: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ride"
    end
  end

  describe "delete ride" do
    setup [:create_ride]

    test "deletes chosen ride", %{conn: conn, ride: ride} do
      conn = delete(conn, ~p"/rides/#{ride}")
      assert redirected_to(conn) == ~p"/rides"

      assert_error_sent 404, fn ->
        get(conn, ~p"/rides/#{ride}")
      end
    end
  end

  defp create_ride(_) do
    ride = ride_fixture()

    %{ride: ride}
  end
end
