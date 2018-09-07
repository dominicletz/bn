defmodule BN.PairingTest do
  use ExUnit.Case, async: true

  alias BN.{Pairing, FQ2, BN128Arithmetic, FQ}

  describe "twist/1" do
    test "twists fq2 point to fq12" do
      x =
        FQ2.new([
          10_857_046_999_023_057_135_944_570_762_232_829_481_370_756_359_578_518_086_990_519_993_285_655_852_781,
          11_559_732_032_986_387_107_991_004_021_392_285_783_925_812_861_821_192_530_917_403_151_452_391_805_634
        ])

      y =
        FQ2.new([
          8_495_653_923_123_431_417_604_973_247_489_272_438_418_190_587_263_600_148_770_280_649_306_958_101_930,
          4_082_367_875_863_433_681_332_203_403_145_435_568_316_851_327_593_401_208_105_741_076_214_120_093_531
        ])

      {result_x, result_y} = twisted = Pairing.twist({x, y})
      assert BN128Arithmetic.on_curve?(twisted)

      expected_x_coordinates = [
        0,
        0,
        16_260_673_061_341_949_275_257_563_295_988_632_869_519_996_389_676_903_622_179_081_103_440_260_644_990,
        0,
        0,
        0,
        0,
        0,
        11_559_732_032_986_387_107_991_004_021_392_285_783_925_812_861_821_192_530_917_403_151_452_391_805_634,
        0,
        0,
        0
      ]

      expected_y_coordinates = [
        0,
        0,
        0,
        15_530_828_784_031_078_730_107_954_109_694_902_500_959_150_953_518_636_601_196_686_752_670_329_677_317,
        0,
        0,
        0,
        0,
        0,
        4_082_367_875_863_433_681_332_203_403_145_435_568_316_851_327_593_401_208_105_741_076_214_120_093_531,
        0,
        0
      ]

      result_x.coef
      |> Enum.zip(expected_x_coordinates)
      |> Enum.each(fn {result, expected} ->
        assert result.value == expected
      end)

      result_y.coef
      |> Enum.zip(expected_y_coordinates)
      |> Enum.each(fn {result, expected} ->
        assert result.value == expected
      end)
    end
  end

  describe "point_to_fq12/1" do
    test "converts fq point to fq12" do
      x = FQ.new(1)
      y = FQ.new(2)

      point = {x, y}

      {result_x, result_y} = Pairing.point_to_fq12(point)

      expected_x = [x.value] ++ List.duplicate(0, 11)
      expected_y = [y.value] ++ List.duplicate(0, 11)

      result_y.coef
      |> Enum.zip(expected_y)
      |> Enum.each(fn {result, expected} ->
        assert result.value == expected
      end)

      result_x.coef
      |> Enum.zip(expected_x)
      |> Enum.each(fn {result, expected} ->
        assert result.value == expected
      end)
    end
  end
end
