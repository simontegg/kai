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
      biotin_ai: 0.03,
      folate_dfe_rda: 0.4,
      niacin_ne_rda: 16,

      calories: 3083
    }
  end

end


