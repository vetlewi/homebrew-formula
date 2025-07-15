class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "a885b1e220788d83e709003e8adc00cbc7af07bc7c325186012844ab69844280"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "0f033d2395a4704a2b063a2cc0af5a42a234f1f81c0eae5e0328d7f31c42f98b"
    sha256 cellar: :any, arm64_sonoma:  "557d2d2b79f18c543741e18347dcb99ecd6d8f14b82c661b4b25555b719cd1c3"
    sha256 cellar: :any, ventura:       "d425d6516902f16caa3a4c314d00daa7ae812ccdd9d8202a44dc547fe44889f8"
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
