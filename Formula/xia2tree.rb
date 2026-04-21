class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "059f35d8a0027f20962ca2693d13dfdb6f7eda55fd0776ddd9a24890eb817074"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "7e33cf7eee9764086c05f55ed61c1105163cf1fa9b8c52ef9b00d1e71d925390"
    sha256 cellar: :any, arm64_sequoia: "dead219fc348824f290382de0ca5321a53bfd625d15fc846c61c23ef54f8a8cc"
    sha256 cellar: :any, arm64_sonoma:  "da5a9bc9d5c12c8ace6d263b6f0d4b13d6d4c1440568da4c0827a2b7fb47b6b4"
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
