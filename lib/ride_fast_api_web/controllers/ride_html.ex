defmodule RideFastApiWeb.RideHTML do
  use RideFastApiWeb, :html

  embed_templates "ride_html/*"

  @doc """
  Renders a ride form.

  The form is defined in the template at
  ride_html/ride_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def ride_form(assigns)
end
