defmodule Kai.Utils do
  def validate_extension(allowed, file) do
    file_extension =
      file.file_name
      |> Path.extname
      |> String.downcase
    Enum.member?(allowed, file_extension)
  end

  def is_numeric(str) do
    case Float.parse(str) do
      {_num, ""} -> true
      {_num, _r} -> false               # _r : remainder_of_bianry
      :error     -> false
    end
  end

end
