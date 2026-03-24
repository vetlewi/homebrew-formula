class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "d8ac4097f765055197ae5ca2e88b6f3fa41b69b551f96fec85cfb9bb8d8c1ae5"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "43cced8025f4d69f6e2c53d551dae95c6fc992bfbce13bfb5155f862f12da74c"
    sha256 cellar: :any, arm64_sequoia: "86822d4096030f160c6b16ebb518ae785bc8a3b056b0e5c2e8b358a091228162"
    sha256 cellar: :any, arm64_sonoma:  "3fc9b265486ba82701a7ee9cab410d5308cbf1a477607850069bf63c8f177dfe"
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
