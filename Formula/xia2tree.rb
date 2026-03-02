class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "afb6814c4fcdb85b999bd1ea74d0da6a93008272ef2b1a3a037be4cf4b972a81"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "8e616745aa0d7d02d30253152ccb957f762619aff57ebb60674c047e6f20dfc7"
    sha256 cellar: :any, arm64_sequoia: "eef8b3b72dd255efa34df3c0514e58b69d04b38733d014033e598d60a81859f2"
    sha256 cellar: :any, arm64_sonoma:  "42828dc220f0964ff8c1237dd1203e2b52e817ba08c4d207cd514a34451a907f"
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
