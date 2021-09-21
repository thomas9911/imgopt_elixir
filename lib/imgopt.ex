defmodule Imgopt do
  use Rustler,
    otp_app: :imgopt,
    crate: "imgopt",
    mode: :release,
    default_features: false

  def convert(_, _), do: :erlang.nif_error(:nif_not_loaded)

  def convert!(input, output) do
    case convert(input, output) do
      :ok -> :ok
      {:error, error} -> raise error
    end
  end

  def convert_explicit(_, _, _, _), do: :erlang.nif_error(:nif_not_loaded)
end
