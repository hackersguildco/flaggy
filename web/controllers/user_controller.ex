defmodule Flaggy.UserController do
    use Flaggy.Web, :controller

    alias Flaggy.User

    def show(conn, %{"id" => id}) do
      user = Repo.get!(User, id)
      render(conn, "show.html", user: user, layout: false)
    end

end
