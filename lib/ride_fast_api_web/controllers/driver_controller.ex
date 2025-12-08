defmodule RideFastApiWeb.DriverController do
  use RideFastApiWeb, :controller

  alias RideFastApi.Drivers
  alias RideFastApi.Drivers.Driver

  def index(conn, params) do
    drivers = Drivers.list_drivers_filtered(params)
    json_data = %{
      drivers: Enum.map(drivers, fn %RideFastApi.Drivers.Driver{id: id, name: name, email: email, phone: phone, status: status} ->
        %{
          id: id,
          name: name,
          email: email,
          phone: phone,
          status: status
        }
      end)
    }

  json(conn, json_data)
  end

  def drives_languages_index(conn, %{"driver_id" => driver_id}) do
    languages = RideFastApi.Drivers.get_languages_by_driver(driver_id)

    json_data = %{
      languages: Enum.map(languages, fn %RideFastApi.Languages.Lenguage{id: id, code: code, name: name} ->
        %{
          id: id,
          code: code,
          name: name
        }
      end)
    }

    json(conn, json_data)
  end

  def new(conn, _params) do
    changeset = Drivers.change_driver(%Driver{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"driver" => driver_params}) do
    case Drivers.create_driver(driver_params) do
      {:ok, driver} ->
        conn
        |> put_flash(:info, "Driver created successfully.")
        |> redirect(to: ~p"/drivers/#{driver}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    driver = Drivers.get_driver!(id)
    render(conn, :show, driver: driver)
  end

  def edit(conn, %{"id" => id}) do
    driver = Drivers.get_driver!(id)
    changeset = Drivers.change_driver(driver)
    render(conn, :edit, driver: driver, changeset: changeset)
  end

  def update(conn, %{"id" => id, "driver" => driver_params}) do
    driver = Drivers.get_driver!(id)

    case Drivers.update_driver(driver, driver_params) do
      {:ok, driver} ->
        conn
        |> put_flash(:info, "Driver updated successfully.")
        |> redirect(to: ~p"/drivers/#{driver}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, driver: driver, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    driver = Drivers.get_driver!(id)
    {:ok, _driver} = Drivers.delete_driver(driver)

    conn
    |> put_flash(:info, "Driver deleted successfully.")
    |> redirect(to: ~p"/drivers")
  end
end
