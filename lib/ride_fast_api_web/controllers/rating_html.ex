defmodule RideFastApiWeb.RatingHTML do
  use RideFastApiWeb, :html

  embed_templates "rating_html/*"

  @doc """
  Renders a rating form.

  The form is defined in the template at
  rating_html/rating_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def rating_form(assigns)
end
