defmodule RideFastApiWeb.VehicleHTML do
  use RideFastApiWeb, :html

  embed_templates "vehicle_html/*"

  @doc """
  Renders a vehicle form.

  The form is defined in the template at
  vehicle_html/vehicle_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def vehicle_form(assigns)
end
