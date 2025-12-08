defmodule RideFastApiWeb.LenguageHTML do
  use RideFastApiWeb, :html

  embed_templates "lenguage_html/*"

  @doc """
  Renders a lenguage form.

  The form is defined in the template at
  lenguage_html/lenguage_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def lenguage_form(assigns)
end
