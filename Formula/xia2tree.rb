class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.8.tar.gz"
  # version "0.9.6"
  sha256 "f6cef166180491ef6bf96500d742b5d8009ae8a57a65674a9f60b1503bd8242c"

  depends_on "cmake" => [:build, :test]
  depends_on "root"

  def install
    mkdir "XIA2tree-build" do
      args = std_cmake_args + %w[
        ../
        -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      ]
      system "cmake", *args
      system "cmake", "--build", ".", "-j"
      system "cmake", "--install", "."
    end
  end
end
