class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "61aeba0611f98f3a5ab1bee01c94452d2a49a53fdc86a7261f86d0f907836d25"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "0528787cfc0cf172942fddeeb114b890296ad1611f3e7fbe578d42ed1e1180b6"
    sha256 cellar: :any, arm64_sequoia: "0827d08012cd16d3061fbc89b99ad94657a60be69b6184bbf753de8f208af669"
    sha256 cellar: :any, arm64_sonoma:  "47d1123a408a07865a706c50d32d77aaec899a704166d6e33e058c7d689221b7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "root"

  def install
    mkdir "XIA2tree-build" do
      args = std_cmake_args + %w[
        ../
        -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      ]
      args.map! do |arg|
        arg.gsub("-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_BUILD_TYPE=RelWithDeb")
      end
      system "cmake", *args
      system "cmake", "--build", ".", "-j"
      system "cmake", "--install", "."
    end
  end
end
