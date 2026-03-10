class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "038fa1758df22309b8d092bd3c484057cdba807265cf91a56c5330f4ee039044"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "155c208801c335907e0437d7369fae3d52eb803d900d17461bb836bd2593ca71"
    sha256 cellar: :any, arm64_sequoia: "863f26dc8a0211648116ed418286a2d0bd53b72c9fb081eb52af64525bf813c4"
    sha256 cellar: :any, arm64_sonoma:  "b67be5e7a70fcef5f6fb5e7dce761e927813e636d00ea682bb3a3a82d43e6ed3"
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
