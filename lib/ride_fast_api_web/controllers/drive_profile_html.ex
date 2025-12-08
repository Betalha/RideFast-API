defmodule RideFastApiWeb.Drive_profileHTML do
  use RideFastApiWeb, :html

  embed_templates "drive_profile_html/*"

  @doc """
  Renders a drive_profile form.

  The form is defined in the template at
  drive_profile_html/drive_profile_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def drive_profile_form(assigns)
end
