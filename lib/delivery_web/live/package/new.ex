defmodule DeliveryWeb.PackageLive.New do
  use Phoenix.LiveView

  alias DeliveryWeb.PackageView
  alias DeliveryWeb.Router.Helpers, as: Routes
  alias Delivery.Packages
  alias Delivery.Packages.Package

  def mount(_session, socket) do

    {:ok,
     assign(socket, %{
       changeset: Packages.change_package(%Package{version: "1.0.0"})
     })}
  end

  def render(assigns), do: PackageView.render("new.html", assigns)

  def handle_event("validate", %{"package" => params}, socket) do

    changeset =
      Package.changeset(%Package{}, params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end


  def handle_event("save", %{"package" => package_params}, socket) do
    case Packages.create_package(package_params) do
      {:ok, package} ->
        {:stop,
         socket
         |> put_flash(:info, "Package created successfully.")
         |> redirect(to: Routes.package_path(DeliveryWeb.Endpoint, :show, package))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
