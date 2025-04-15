class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.9.tar.gz"
  # version "0.9.6"
  sha256 "a885b1e220788d83e709003e8adc00cbc7af07bc7c325186012844ab69844280"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_sequoia: "3996fb0915fc800b12cea38dc4d432598c269ea4f5f16716fc5775d5c89805f7"
    sha256 cellar: :any, arm64_sonoma:  "41544287c5979c158eae96841e27618e150ce1c86dd90979b3148201581cb552"
    sha256 cellar: :any, ventura:       "c48619a0e301c9e0e7df3b8715cebda097eaafc6a545bd7c364dc8ecdb400c03"
  end

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
