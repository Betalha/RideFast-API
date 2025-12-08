defmodule RideFastApi.RatingsTest do
  use RideFastApi.DataCase

  alias RideFastApi.Ratings

  describe "ratings" do
    alias RideFastApi.Ratings.Rating

    import RideFastApi.RatingsFixtures

    @invalid_attrs %{comment: nil, ride_id: nil, from_user_id: nil, to_driver_id: nil, score: nil}

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Ratings.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Ratings.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      valid_attrs = %{comment: "some comment", ride_id: 42, from_user_id: 42, to_driver_id: 42, score: 42}

      assert {:ok, %Rating{} = rating} = Ratings.create_rating(valid_attrs)
      assert rating.comment == "some comment"
      assert rating.ride_id == 42
      assert rating.from_user_id == 42
      assert rating.to_driver_id == 42
      assert rating.score == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ratings.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      update_attrs = %{comment: "some updated comment", ride_id: 43, from_user_id: 43, to_driver_id: 43, score: 43}

      assert {:ok, %Rating{} = rating} = Ratings.update_rating(rating, update_attrs)
      assert rating.comment == "some updated comment"
      assert rating.ride_id == 43
      assert rating.from_user_id == 43
      assert rating.to_driver_id == 43
      assert rating.score == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Ratings.update_rating(rating, @invalid_attrs)
      assert rating == Ratings.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Ratings.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Ratings.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Ratings.change_rating(rating)
    end
  end
end
