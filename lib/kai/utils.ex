defmodule Kai.Utils do
  def validate_extension(allowed, file) do
    file_extension =
      file.file_name
      |> Path.extname
      |> String.downcase
    Enum.member?(allowed, file_extension)
  end

end
