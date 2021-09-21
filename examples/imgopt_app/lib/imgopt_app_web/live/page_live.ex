defmodule ImgoptAppWeb.PageLive do
  use ImgoptAppWeb, :live_view

  require Logger

  @prefix "priv/uploaded"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png .svg), max_entries: 1)}
  end

  @impl true
  def handle_event("validate-upload", _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl true
  def handle_event("upload", _params, socket) do
    case consume_uploaded_entries(socket, :avatar, fn %{path: path},
                                                      %{client_type: client_type} ->
           format = client_type_to_format(client_type)
           {outfile, redirect_to} = to_static_path(path, format)

           Imgopt.convert_explicit(
             path,
             format,
             outfile,
             format
           )

           Routes.image_path(ImgoptAppWeb.Endpoint, :index, redirect_to)
         end) do
      [] ->
        {:noreply, socket}

      [redirect_to] ->
        {:noreply, update(socket, :uploaded_files, &(&1 ++ [redirect_to]))}
    end
  end

  def client_type_to_format("image/jpeg"), do: :jpeg
  def client_type_to_format("image/png"), do: :png
  def client_type_to_format("image/svg"), do: :svg

  defp to_static_path(path, extension) do
    filename = "#{Path.basename(path)}.#{extension}"
    path = Application.app_dir(:imgopt_app, @prefix <> "/#{filename}")

    {path, filename}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
