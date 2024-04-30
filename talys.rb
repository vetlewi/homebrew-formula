class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.0-fixed.tar.gz"
  version "2.0"
  sha256 "040719351b870dec36a18c7c52dba1a33be15e7972e0f0f07311921e8471c497"
  license "MIT"



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
