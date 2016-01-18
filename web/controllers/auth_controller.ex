defmodule Flaggy.AuthController do
  use Flaggy.Web, :controller
  alias Flaggy.User

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    token = get_token!(provider, code)

    # Request the user's data with the access token
    user = get_user!(provider, token)

    {:ok, user_saved} =
      case Repo.get(User, user[:fb_id]) do
        nil ->
          changeset = User.changeset(%User{}, user)
          Repo.insert(changeset)
        user_found ->
          changeset = User.changeset(user_found, user)
          Repo.update(changeset)
      end

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.

    # Creates the image
    user_updated = Flaggy.ProcessPhoto.process(user_saved)

    conn
    |> put_session(:current_user, user_updated)
    |> put_session(:access_token, token.access_token)
    |> redirect(to: "/")
  end

  defp authorize_url!("facebook"), do: Facebook.authorize_url!(scope: "user_photos")
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("facebook", code), do: Facebook.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("facebook", token) do
    {:ok, %{body: user}} = OAuth2.AccessToken.get(token, "/me", fields: "id,name")
    %{fb_id: user["id"], name: user["name"], avatar: "https://graph.facebook.com/#{user["id"]}/picture?width200&height=200",
    token: token.access_token}
  end
end
