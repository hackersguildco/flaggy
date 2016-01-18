defmodule Flaggy.Image do
  use Arc.Definition
  use Arc.Ecto.Definition

  # convert -ping -format '%wx%h^' me.jpg info:-
  #convert me.jpg flag.png -compose softlight -resize '960x960^' -gravity center -composite -quality 100 demo.jpg

  @versions [:original]
  @acl :public_read

  def __storage, do: Application.get_env(:arc, :arc_storage)

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Whitelist file extensions:
  # def validate({file, _}) do
  #   ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  # end

  # Define a thumbnail transformation:
  # def transform(:thumb, _) do
  #   {:convert, "file_path #{@flag_path} -compose softlight -resize  200x200^  -gravity center -composite -quality 100 -format png"}
  # end

  # Override the persisted filenames:
  # def filename(version, _) do
  #   version
  # end

  # Override the storage directory:
  # def storage_dir(version, {file, scope}) do
  #   "uploads/user/avatars/#{scope.id}"
  # end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end
end
