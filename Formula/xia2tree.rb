class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "63d8718423af4985f663702c0d8a5508eccbb3e96cb337884595bcfdafe3ab33"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_sequoia: "ee1a86cda8e5b64a212ad774b8f5303986e6604afccc13139beae644fad45e9b"
    sha256 cellar: :any, arm64_sonoma:  "bd713e147b5f548072a36f2f8df96740d37e484cb0c1e2d1efff3b1d568a1fc5"
    sha256 cellar: :any, ventura:       "7a9d5f65755871707d35be496534883767c13854b4b577c82c01f115e3f0f1b5"
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
