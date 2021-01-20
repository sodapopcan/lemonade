defmodule LemonadeWeb.ViewHelpersTest do
  use ExUnit.Case, async: true

  import LemonadeWeb.ViewHelpers

  describe "view helpers" do
    test "initials" do
      assert initials("Hubert Farnsworth") == "HF"
      assert initials("Philip J. Fry") == "PF"
      assert initials("Leela") == "L"
      assert initials("ålmond Man") == "åM"
    end
  end
end
