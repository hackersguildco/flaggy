defmodule Flaggy.PageController do
  use Flaggy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def upload(conn, _params) do
    user = get_session(conn, :current_user)
    access_token = get_session(conn, :access_token)
    spawn Flaggy.ProcessPhoto, :process, [user, access_token]
    render conn, "index.html"
  end
end
