class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "91afd8aab4998f10aebf910aba68b821ea8d4227becce5fffb1dbdac745fbe22"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_tahoe:   "b3449279a46505eb7f08cfbe4f06e5a752076ad8f9b06c431ad2fd887e211da0"
    sha256 cellar: :any, arm64_sequoia: "a4b40f3bd966ae44a69349918f68c25875d398e99dc8ba840296ec4236b3d9ac"
    sha256 cellar: :any, arm64_sonoma:  "1e2b8111877cd605df9ef4db96436bcbb64b5486644be207f40c7ae44f8a1aa2"
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
