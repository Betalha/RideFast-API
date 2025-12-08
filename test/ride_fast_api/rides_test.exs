defmodule RideFastApi.RidesTest do
  use RideFastApi.DataCase

  alias RideFastApi.Rides

  describe "rides" do
    alias RideFastApi.Rides.Ride

    import RideFastApi.RidesFixtures

    @invalid_attrs %{status: nil, started_at: nil, driver_id: nil, user_id: nil, vehicle_id: nil, origen_lat: nil, origen_lng: nil, price_estimate: nil, final_price: nil, request_at: nil, endend_at: nil}

    test "list_rides/0 returns all rides" do
      ride = ride_fixture()
      assert Rides.list_rides() == [ride]
    end

    test "get_ride!/1 returns the ride with given id" do
      ride = ride_fixture()
      assert Rides.get_ride!(ride.id) == ride
    end

    test "create_ride/1 with valid data creates a ride" do
      valid_attrs = %{status: "some status", started_at: ~N[2025-12-06 23:51:00], driver_id: 42, user_id: 42, vehicle_id: 42, origen_lat: "120.5", origen_lng: "120.5", price_estimate: "120.5", final_price: "120.5", request_at: ~N[2025-12-06 23:51:00], endend_at: ~N[2025-12-06 23:51:00]}

      assert {:ok, %Ride{} = ride} = Rides.create_ride(valid_attrs)
      assert ride.status == "some status"
      assert ride.started_at == ~N[2025-12-06 23:51:00]
      assert ride.driver_id == 42
      assert ride.user_id == 42
      assert ride.vehicle_id == 42
      assert ride.origen_lat == Decimal.new("120.5")
      assert ride.origen_lng == Decimal.new("120.5")
      assert ride.price_estimate == Decimal.new("120.5")
      assert ride.final_price == Decimal.new("120.5")
      assert ride.request_at == ~N[2025-12-06 23:51:00]
      assert ride.endend_at == ~N[2025-12-06 23:51:00]
    end

    test "create_ride/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rides.create_ride(@invalid_attrs)
    end

    test "update_ride/2 with valid data updates the ride" do
      ride = ride_fixture()
      update_attrs = %{status: "some updated status", started_at: ~N[2025-12-07 23:51:00], driver_id: 43, user_id: 43, vehicle_id: 43, origen_lat: "456.7", origen_lng: "456.7", price_estimate: "456.7", final_price: "456.7", request_at: ~N[2025-12-07 23:51:00], endend_at: ~N[2025-12-07 23:51:00]}

      assert {:ok, %Ride{} = ride} = Rides.update_ride(ride, update_attrs)
      assert ride.status == "some updated status"
      assert ride.started_at == ~N[2025-12-07 23:51:00]
      assert ride.driver_id == 43
      assert ride.user_id == 43
      assert ride.vehicle_id == 43
      assert ride.origen_lat == Decimal.new("456.7")
      assert ride.origen_lng == Decimal.new("456.7")
      assert ride.price_estimate == Decimal.new("456.7")
      assert ride.final_price == Decimal.new("456.7")
      assert ride.request_at == ~N[2025-12-07 23:51:00]
      assert ride.endend_at == ~N[2025-12-07 23:51:00]
    end

    test "update_ride/2 with invalid data returns error changeset" do
      ride = ride_fixture()
      assert {:error, %Ecto.Changeset{}} = Rides.update_ride(ride, @invalid_attrs)
      assert ride == Rides.get_ride!(ride.id)
    end

    test "delete_ride/1 deletes the ride" do
      ride = ride_fixture()
      assert {:ok, %Ride{}} = Rides.delete_ride(ride)
      assert_raise Ecto.NoResultsError, fn -> Rides.get_ride!(ride.id) end
    end

    test "change_ride/1 returns a ride changeset" do
      ride = ride_fixture()
      assert %Ecto.Changeset{} = Rides.change_ride(ride)
    end
  end
end
