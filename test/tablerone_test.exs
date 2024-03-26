defmodule TableroneTest do
  # @related [subject](lib/tablerone.ex)
  use ExUnit.Case
  doctest Tablerone

  describe "icon" do
    test "returns the contents of a cached icon" do
      assert Tablerone.icon(:cactus_off, :outline) ==
               """
               <svg
                 xmlns=\"http://www.w3.org/2000/svg\"
                 width=\"24\"
                 height=\"24\"
                 viewBox=\"0 0 24 24\"
                 fill=\"none\"
                 stroke=\"currentColor\"
                 stroke-width=\"2\"
                 stroke-linecap=\"round\"
                 stroke-linejoin=\"round\"
               >
                 <path d=\"M6 9v1a3 3 0 0 0 3 3h1\" />
                 <path d=\"M18 8v5a3 3 0 0 1 -.129 .872m-2.014 2a3 3 0 0 1 -.857 .124h-1\" />
                 <path d=\"M10 21v-11m0 -4v-1a2 2 0 1 1 4 0v5m0 4v7\" />
                 <path d=\"M7 21h10\" />
                 <path d=\"M3 3l18 18\" />
               </svg>
               """
               |> String.trim()
    end

    test "raises when the icon has not been cached" do
      assert_raise ArgumentError,
                   """
                   Icon `cactus` has not been downloaded.

                   To download this icon to the local application, run the following in a terminal:

                       mix tablerone.download --type filled cactus
                   """,
                   fn -> Tablerone.icon(:cactus, :filled) end
    end

    test "dasherizes atom icon when icon has not been cached" do
      assert_raise ArgumentError,
                   """
                   Icon `user-circle` has not been downloaded.

                   To download this icon to the local application, run the following in a terminal:

                       mix tablerone.download --type outline user-circle
                   """,
                   fn -> Tablerone.icon(:user_circle, :outline) end
    end
  end

  describe "path" do
    test "returns a dasherized svg file name in the local priv dir" do
      assert Tablerone.path("some_icon_name", :outline) ==
               Path.join([:code.priv_dir(:tablerone), "tablerone", "outline", "some-icon-name.svg"])
    end

    test "can take a dasherized string" do
      assert Tablerone.path("some-icon-name", :filled) ==
               Path.join([:code.priv_dir(:tablerone), "tablerone", "filled", "some-icon-name.svg"])
    end
  end
end
