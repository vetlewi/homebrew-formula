class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "b1f58b39ccf57e8fee837a5843e06df1a53d95b65b3c7aa441f118174aec0792"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "f1ba124a14e28e1422ce60dbc40bd37f18628fcccf0fc5b1942be678bb610ee1"
    sha256 cellar: :any, arm64_sequoia: "5fde96d4d7f2e2af2dd8710f451c8fccf15d45021afa07e200384fe3a9a8feed"
    sha256 cellar: :any, arm64_sonoma:  "e57ca5df0b574267c8b4b38b30be8ecd630cb13a17613ababc4274f0f3157cfa"
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
