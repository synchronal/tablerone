defmodule TableroneTest do
  use ExUnit.Case
  doctest Tablerone

  describe "icon" do
    test "returns the contents of a cached icon" do
      assert Tablerone.icon(:cactus_off) ==
               """
               <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-cactus-off" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
                 <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
                 <path d="M6 9v1a3 3 0 0 0 3 3h1" />
                 <path d="M18 8v5a3 3 0 0 1 -.129 .872m-2.014 2a3 3 0 0 1 -.857 .124h-1" />
                 <path d="M10 21v-11m0 -4v-1a2 2 0 1 1 4 0v5m0 4v7" />
                 <path d="M7 21h10" />
                 <path d="M3 3l18 18" />
               </svg>
               """
               |> String.trim()
    end

    test "raises when the icon has not been cached" do
      assert_raise ArgumentError,
                   """
                   Icon `cactus` has not been downloaded.

                   To download this icon to the local application, run the following in a terminal:

                       mix tablerone.download cactus
                   """,
                   fn -> Tablerone.icon(:cactus) end
    end

    test "dasherizes atom icon when icon has not been cached" do
      assert_raise ArgumentError,
                   """
                   Icon `user-circle` has not been downloaded.

                   To download this icon to the local application, run the following in a terminal:

                       mix tablerone.download user-circle
                   """,
                   fn -> Tablerone.icon(:user_circle) end
    end
  end

  describe "path" do
    test "returns a dasherized svg file name in the local priv dir" do
      assert Tablerone.path(:some_icon_name) ==
               Path.join([:code.priv_dir(:tablerone), "tablerone", "some-icon-name.svg"])
    end

    test "can take a dasherized string" do
      assert Tablerone.path("some-icon-name") ==
               Path.join([:code.priv_dir(:tablerone), "tablerone", "some-icon-name.svg"])
    end
  end
end
