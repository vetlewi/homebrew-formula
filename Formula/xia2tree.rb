class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "9e0f1f24cbf1f52b62c66984a02367c69352b351367080d4365a3c65bf2e22a6"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "7d7c9331c9ba4889f8bb06eaa5fd15c8890644b77f00b201e37106bc623ca814"
    sha256 cellar: :any, arm64_sequoia: "4f7137bd427b7b9610e8ab2b087d2c6170e88215a0239aca8f9d9f9699e42e86"
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

  test do
    assert_predicate bin/"XIA2tree", :executable?
  end
end
