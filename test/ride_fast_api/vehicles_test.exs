defmodule RideFastApi.VehiclesTest do
  use RideFastApi.DataCase

  alias RideFastApi.Vehicles

  describe "vehicles" do
    alias RideFastApi.Vehicles.Vehicle

    import RideFastApi.VehiclesFixtures

    @invalid_attrs %{active: nil, driver_id: nil, color: nil, plate: nil, model: nil, seats: nil}

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Vehicles.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Vehicles.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      valid_attrs = %{active: true, driver_id: 42, color: "some color", plate: "some plate", model: "some model", seats: 42}

      assert {:ok, %Vehicle{} = vehicle} = Vehicles.create_vehicle(valid_attrs)
      assert vehicle.active == true
      assert vehicle.driver_id == 42
      assert vehicle.color == "some color"
      assert vehicle.plate == "some plate"
      assert vehicle.model == "some model"
      assert vehicle.seats == 42
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      update_attrs = %{active: false, driver_id: 43, color: "some updated color", plate: "some updated plate", model: "some updated model", seats: 43}

      assert {:ok, %Vehicle{} = vehicle} = Vehicles.update_vehicle(vehicle, update_attrs)
      assert vehicle.active == false
      assert vehicle.driver_id == 43
      assert vehicle.color == "some updated color"
      assert vehicle.plate == "some updated plate"
      assert vehicle.model == "some updated model"
      assert vehicle.seats == 43
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Vehicles.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Vehicles.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_vehicle(vehicle)
    end
  end
end
