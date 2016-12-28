defmodule Kai.Factory do
  use ExMachina.Ecto, repo: Kai.Repo

  def user_factory do
    %Kai.User{
      name: "me",
      email: "me@example.com",
      age: 31,
      weight: 76,
      height: 175,
      sex: "no answer",
      activity: 2,
      access_token: "abc",

      #vitamin sufficiency
      biotin: 0.03,
      folate_dfe: 0.4,
      niacin_ne: 16,

      calories: 3083
    }
  end

  def constraints_factory do
    %{
      biotin: 0.03,
      folate_dfe: 0.4,
      niacin_ne: 16,
      calories: 3083
    }
  end

  # avocado
  def price_conversion_factory do
    %{
      price: 179,
      quantity: 1,
      quantity_unit: "ea",
      each_g: 170,
      edible_portion: 0.66,
      raw_to_cooked: nil
    }
  end





end


