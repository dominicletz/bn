defmodule BN.FQPTest do
  use ExUnit.Case, async: true

  alias BN.{FQP, FQ}

  describe "new/2" do
    test "creates a new fqp12 field element" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]
      coef = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

      result = FQP.new(coef, modulus_coef)

      assert result.modulus_coef == modulus_coef
      assert result.dim == 12

      result.coef
      |> Enum.zip(coef)
      |> Enum.each(fn {fq_coef, coef} ->
        assert fq_coef.value == coef
      end)
    end
  end

  describe "add/2" do
    test "add two fqp12 field elements" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]
      coef1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      coef2 = Enum.reverse(coef1)

      fqp1 = FQP.new(coef1, modulus_coef)
      fqp2 = FQP.new(coef2, modulus_coef)

      result = FQP.add(fqp1, fqp2)

      assert result.modulus_coef == modulus_coef
      assert result.dim == 12

      result.coef
      |> Enum.zip(coef1)
      |> Enum.zip(coef2)
      |> Enum.each(fn {{fq_coef, coef1}, coef2} ->
        assert fq_coef.value == coef1 + coef2
      end)
    end
  end

  describe "sub/2" do
    test "substract two fqp12 field elements" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]
      coef1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      coef2 = Enum.reverse(coef1)

      fqp1 = FQP.new(coef1, modulus_coef)
      fqp2 = FQP.new(coef2, modulus_coef)

      result = FQP.sub(fqp2, fqp1)

      assert result.modulus_coef == modulus_coef
      assert result.dim == 12

      result.coef
      |> Enum.zip(coef1)
      |> Enum.zip(coef2)
      |> Enum.each(fn {{fq_coef, coef1}, coef2} ->
        fq1 = FQ.new(coef2)
        fq2 = FQ.new(coef1)

        assert fq_coef == FQ.sub(fq1, fq2)
      end)
    end
  end

  describe "mult/2" do
    test "multiplies fq12 with fq" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]
      coef = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

      fqp = FQP.new(coef, modulus_coef)
      fq = FQ.new(2)

      result = FQP.mult(fqp, fq)

      assert result.dim == fqp.dim
      assert result.modulus_coef == modulus_coef

      result.coef
      |> Enum.zip(fqp.coef)
      |> Enum.each(fn {res_coef, fqp_coef} ->
        assert res_coef == FQ.mult(fqp_coef, fq)
      end)
    end

    test "multiplies fq12 with integer" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]
      coef = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

      fqp = FQP.new(coef, modulus_coef)
      integer = 2

      result = FQP.mult(fqp, 2)

      assert result.dim == fqp.dim
      assert result.modulus_coef == modulus_coef

      result.coef
      |> Enum.zip(fqp.coef)
      |> Enum.each(fn {res_coef, fqp_coef} ->
        assert res_coef == FQ.mult(fqp_coef, integer)
      end)
    end

    test "multiplies fq12 element to 1" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]

      coef1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      fpq1 = FQP.new(coef1, modulus_coef)

      coef2 = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      fpq2 = FQP.new(coef2, modulus_coef)

      assert FQP.mult(fpq1, fpq2) == fpq1
    end

    test "multiplies two fq12 elements" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]
      coef1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      fpq1 = FQP.new(coef1, modulus_coef)

      coef2 = [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
      fpq2 = FQP.new(coef2, modulus_coef)

      expected_coef = [
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_225_925_531,
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_226_005_668,
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_226_073_843,
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_226_128_497,
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_226_168_071,
        21_888_242_871_839_275_222_246_405_745_257_275_088_696_311_157_297_823_662_689_037_894_645_226_191_006,
        49_296,
        35_878,
        24_436,
        15_229,
        8516,
        4556
      ]

      result1 = FQP.mult(fpq1, fpq2)

      result1.coef
      |> Enum.zip(expected_coef)
      |> Enum.each(fn {fpcoef, coef} ->
        assert fpcoef.value == coef
      end)

      result2 = FQP.mult(fpq2, fpq1)

      assert result1 == result2
    end
  end

  describe "inverse/1" do
    test "calculates inverse of fqp12 element" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]

      coef = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      fpq = FQP.new(coef, modulus_coef)

      res = FQP.inverse(fpq)

      expected_result = [
        15_374_259_089_530_920_486_954_108_410_929_816_790_118_611_324_082_378_089_409_762_753_204_697_760_634,
        15_522_010_041_431_329_291_860_390_278_399_668_584_078_556_069_590_201_987_280_948_002_544_674_244_273,
        68_022_260_863_823_743_347_377_227_287_641_796_538_272_231_388_872_913_831_466_339_891_934_772_537,
        18_379_734_506_036_723_734_667_889_612_980_182_924_577_003_798_278_207_186_085_931_552_493_878_713_931,
        4_142_838_114_924_082_811_005_677_060_202_405_138_285_522_848_420_353_144_132_994_781_449_574_643_173,
        17_109_344_097_949_857_168_631_823_265_500_346_857_012_536_889_224_507_642_359_481_985_842_495_899_252,
        9_948_347_373_262_575_965_554_824_458_897_571_642_512_138_219_001_448_783_255_449_543_931_123_492_015,
        12_921_816_282_347_125_285_315_019_359_583_664_420_260_144_598_209_537_204_134_897_385_571_466_837_799,
        14_579_431_102_900_616_518_386_503_897_964_591_551_805_796_904_912_841_718_065_807_406_261_872_232_914,
        1_847_733_261_220_391_269_213_417_796_051_502_538_790_338_884_054_083_994_265_704_494_469_045_803_163,
        3_655_464_119_449_516_550_553_239_117_844_740_991_949_296_371_600_756_381_424_349_350_509_333_448_623,
        445_123_865_037_066_322_898_963_051_246_736_545_692_599_412_853_025_507_340_755_812_203_195_645_503
      ]

      res.coef
      |> Enum.zip(expected_result)
      |> Enum.each(fn {coef, expected_coef} ->
        assert coef.value == expected_coef
      end)
    end
  end

  describe "div/2" do
    test "divides two fqp12 elements" do
      modulus_coef = [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0]

      coef1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      fpq1 = FQP.new(coef1, modulus_coef)

      coef2 = Enum.reverse(coef1)
      fpq2 = FQP.new(coef2, modulus_coef)

      result = FQP.div(fpq1, fpq2)

      expected_result = [
        2_001_247_856_269_400_534_783_464_798_642_244_941_705_624_433_157_995_071_652_025_834_306_793_838_734,
        18_904_588_598_317_333_438_106_115_287_242_887_735_944_760_612_258_684_573_049_626_722_372_365_857_370,
        11_725_045_245_880_289_105_654_165_921_588_041_216_852_941_697_974_005_748_335_459_146_530_820_202_604,
        17_587_369_617_680_612_996_641_773_727_342_092_746_980_544_475_165_115_214_126_727_977_144_691_649_695,
        4_520_931_156_395_251_407_274_372_724_541_981_472_622_844_479_493_870_509_950_724_511_214_447_261_327,
        3_281_985_365_647_403_453_944_655_277_569_163_543_001_631_339_987_988_712_623_070_731_022_692_501_618,
        18_027_820_706_806_974_979_850_935_502_925_632_344_882_536_958_778_219_925_185_735_142_621_021_404_356,
        10_475_183_300_737_621_962_360_744_127_074_641_787_972_898_622_776_430_310_815_134_556_060_678_848_979,
        21_632_475_233_612_772_848_436_425_569_148_478_204_882_929_409_445_248_191_403_258_102_149_829_060_585,
        12_829_614_577_814_474_401_013_346_181_160_966_310_971_652_158_073_100_894_337_653_197_410_362_513_736,
        16_982_331_859_403_317_778_610_325_431_052_542_446_321_584_841_778_663_337_272_025_129_864_022_968_005,
        13_878_928_846_595_726_697_655_621_091_736_425_420_729_056_610_923_758_236_151_780_512_268_870_253_763
      ]

      result.coef
      |> Enum.zip(expected_result)
      |> Enum.each(fn {coef, expected_coef} ->
        assert coef.value == expected_coef
      end)
    end
  end
end
