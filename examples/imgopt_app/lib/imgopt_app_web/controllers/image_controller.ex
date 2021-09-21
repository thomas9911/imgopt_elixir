defmodule ImgoptAppWeb.ImageController do
  use ImgoptAppWeb, :controller

  @prefix "priv/uploaded"

  def index(conn, %{"image_file" => image_file}) do
    path = Application.app_dir(:imgopt_app, @prefix <> "/#{Path.basename(image_file)}")
    send_download(conn, {:file, path})
  end
end
