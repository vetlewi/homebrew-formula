class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.0-3.tar.gz"
  version "2.0"
  sha256 "bb4ed0e425b1a7d1d0abf27f6cedf53d95326565666371ed43b9724b8c46231a"
  license "MIT"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 arm64_sonoma: "71b89049fd2009a8c9ac23c999cde5f396020378bbb1db85e43903c22351fc3a"
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  resource "TalysDB" do
    url "https://nds.iaea.org/talys/misc/structure.tar"
    sha256 "c0e5089869085dc92595d2aa04f6f97286f2257d4fffef19f3de0073fab8b568"
  end

  def install
    mkdir "talys_build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "LICENSE"
    pkgshare.install "test/simple.txt"
  end

  def post_install
    (pkgshare/"structure").install resource("TalysDB")
  end

  test do
    assert_match "The TALYS team congratulates you with this successful calculation.",
      shell_output("#{bin}/talys < #{pkgshare}/simple.txt")
  end
end
