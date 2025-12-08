defmodule RideFastApi.LanguagesTest do
  use RideFastApi.DataCase

  alias RideFastApi.Languages

  describe "lenguages" do
    alias RideFastApi.Languages.Lenguage

    import RideFastApi.LanguagesFixtures

    @invalid_attrs %{code: nil, name: nil}

    test "list_lenguages/0 returns all lenguages" do
      lenguage = lenguage_fixture()
      assert Languages.list_lenguages() == [lenguage]
    end

    test "get_lenguage!/1 returns the lenguage with given id" do
      lenguage = lenguage_fixture()
      assert Languages.get_lenguage!(lenguage.id) == lenguage
    end

    test "create_lenguage/1 with valid data creates a lenguage" do
      valid_attrs = %{code: "some code", name: "some name"}

      assert {:ok, %Lenguage{} = lenguage} = Languages.create_lenguage(valid_attrs)
      assert lenguage.code == "some code"
      assert lenguage.name == "some name"
    end

    test "create_lenguage/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Languages.create_lenguage(@invalid_attrs)
    end

    test "update_lenguage/2 with valid data updates the lenguage" do
      lenguage = lenguage_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name"}

      assert {:ok, %Lenguage{} = lenguage} = Languages.update_lenguage(lenguage, update_attrs)
      assert lenguage.code == "some updated code"
      assert lenguage.name == "some updated name"
    end

    test "update_lenguage/2 with invalid data returns error changeset" do
      lenguage = lenguage_fixture()
      assert {:error, %Ecto.Changeset{}} = Languages.update_lenguage(lenguage, @invalid_attrs)
      assert lenguage == Languages.get_lenguage!(lenguage.id)
    end

    test "delete_lenguage/1 deletes the lenguage" do
      lenguage = lenguage_fixture()
      assert {:ok, %Lenguage{}} = Languages.delete_lenguage(lenguage)
      assert_raise Ecto.NoResultsError, fn -> Languages.get_lenguage!(lenguage.id) end
    end

    test "change_lenguage/1 returns a lenguage changeset" do
      lenguage = lenguage_fixture()
      assert %Ecto.Changeset{} = Languages.change_lenguage(lenguage)
    end
  end
end
