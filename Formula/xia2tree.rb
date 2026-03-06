class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "b1f58b39ccf57e8fee837a5843e06df1a53d95b65b3c7aa441f118174aec0792"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "8e848ed0de1814dac7a9d8d655fcda1945683ce68e091d3404412c5930f6f259"
    sha256 cellar: :any, arm64_sequoia: "3dfc87a6fa1f6004c09707aa2716685dbcbc5eb8403d2a6cb6b76e8be20296d3"
    sha256 cellar: :any, arm64_sonoma:  "6013caeb7318c9adda91d29c02096d806a94088dec994f273cb4faca2499cb22"
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
