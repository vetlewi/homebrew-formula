class Xia2tree < Formula
  desc "Toolkit for analysis of raw data from XIA Pixie-16 DGFs"
  homepage "https://github.com/vetlewi/XIA2tree"
  url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "edd4fd1907a536a6310ed7f01dbce934d1d04b44c6d2b3456aa089d261d7c453"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256 cellar: :any, arm64_sequoia: "02fa8cdaf316cb3709a4b249b67fe1704006d21e5772b39d93a9aaa75d95e4e6"
    sha256 cellar: :any, arm64_sonoma:  "c44427f3244a7fced0cf94c50512842be317552615088c5a860aa8ebb641db9a"
    sha256 cellar: :any, ventura:       "6592e9374241c9943ce0c878f91786644bc2c7b02f265b27724b3fd0188db8b0"
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
