defmodule Flaggy.UserView do
  use Flaggy.Web, :view

  def fb_id do
    Facebook.client.client_id
  end

end
