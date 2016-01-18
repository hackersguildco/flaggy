defmodule Flaggy.User do
  use Flaggy.Web, :model
  use Arc.Ecto.Model

  @primary_key {:fb_id, :string, []}
  @derive {Phoenix.Param, key: :fb_id}
  schema "users" do
    field :name, :string
    field :token, :string
    field :avatar, :string
    field :image, Flaggy.Image.Type

    timestamps
  end

  @required_fields ~w(fb_id name token avatar)
  @optional_fields ~w()
  @required_file_fields ~w()
  @optional_file_fields ~w(image)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:fb_id)
    |> cast_attachments(params, @required_file_fields, @optional_file_fields)
  end
end
