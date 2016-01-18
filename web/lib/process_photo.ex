defmodule Flaggy.ProcessPhoto do
  alias Flaggy.Image
  alias Flaggy.Repo
  alias Flaggy.User

  @flag_path "#{System.cwd}/web/static/assets/images/flag.png"
  @tmp_dir Application.get_env(:flaggy, :tmp_dir)

  def process(user) do
    user
    |> download
    |> add_flag
    |> upload
  end

  #private

  defp download(%User{fb_id: fb_id, avatar: avatar} = user) do
    img_url = image_url(avatar)
    {:ok, response} =  HTTPoison.get(img_url)
    file_url = "#{@tmp_dir}#{fb_id}.jpeg"
    File.write!(file_url, response.body)
    {user, file_url}
  end

  defp upload({user, file_url}) do
    Image.store({file_url, user})
    changeset = User.changeset(user, %{ image: file_url })
    {:ok, user_updated} = Repo.update(changeset)
    user_updated
  end

  defp image_url(avatar) do
    {:ok, response} = HTTPoison.get(avatar)
    response.headers
    |> Enum.filter(fn {key, _} -> key == "Location" end)
    |> Enum.map(fn {_, val} -> val end)
    |> hd
  end

  defp add_flag({user, file_url}) do
    new_file_url = "#{@tmp_dir}#{user.fb_id}_new.jpeg"
    {size, _} = System.cmd("convert", ~w(-ping -format '%wx%h^' #{file_url} info:-))
    System.cmd("convert", ~w(#{file_url} #{@flag_path} -compose softlight -resize #{String.replace(size, "'", "")} -gravity center -composite -quality 100 demo.jpg))
    {user, new_file_url}
  end

end
