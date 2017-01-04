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
      niacin_ne: 16.0,

      calories: 3083
    }
  end

  def list_factory do
    %Kai.List{
      name: "a list",
      user: build(:user),
      foods_quantities: build(3, :foods_quantity)
    }
  end

  def food_quantity_factory do
    %Kai.FoodQuantity{
      quantity: 200,
      food_price: build(:food_price),
      list: build(:list)
    }
  end

  def food_price_factory do
    %Kai.FoodPrice{
      food: build(:food),
      price: build(:price),
      conversion: build(:conversion)
    }
  end

  def price_factory do
    %Kai.Price{
      user: build(:user),
      name: "Apple at the market",
      price: 123,
      quantity: 1,
      quantity_unit: 'kg',
      url: nil,
      company_id: "the market"
    }
  end

  def conversion_factory do
    %Kai.Conversion{
      name: "Avocados",
      each_g: 170,
      raw_to_cooked: nil
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

  def user_details_factory do
    %{
      age: 31,
      weight: 76,
      height: 175,
      sex: "male",
      activity: 2
    }
  end





end


