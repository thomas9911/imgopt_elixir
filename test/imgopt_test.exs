defmodule ImgoptTest do
  use ExUnit.Case, async: true
  doctest Imgopt

  test "works, convert" do
    assert :ok ==
             Imgopt.convert(
               "test/data/pexels-abet-llacer-919734.jpg",
               "test/out/pexels-abet-llacer-919734.jpg"
             )
  end

  test "works, convert!" do
    assert :ok ==
             Imgopt.convert!(
               "test/data/pexels-abet-llacer-919734.jpg",
               "test/out/pexels-abet-llacer-919734.jpg"
             )
  end

  test "works, convert_explicit" do
    assert :ok ==
             Imgopt.convert_explicit(
               "test/data/pexels-abet-llacer-919734.jpg",
               :jpeg,
               "test/out/png-file.jpg",
               :png
             )

    possible_png = File.read!("test/out/png-file.jpg")

    # check png header
    assert "PNG" == binary_part(possible_png, 1, 3)
  end

  test "errors on not existing file" do
    assert {:error, _} = Imgopt.convert("nothing.jpg", "nothing.jpg")
  end

  test "errors invalid file type" do
    assert {:error, "txt cannot be optimized"} =
             Imgopt.convert("test/data/text.txt", "test/data/text.txt")
  end

  test "errors invalid output file type" do
    assert {:error, "txt cannot be optimized"} =
             Imgopt.convert("test/data/pexels-abet-llacer-919734.jpg", "test/data/out.txt")
  end

  test "convert! raises on invalid file type" do
    assert_raise RuntimeError, "txt cannot be optimized", fn ->
      Imgopt.convert!("test/data/text.txt", "test/data/text.txt")
    end
  end
end
