class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v1.96-cmake.tar.gz"
  version "1.96"
  sha256 "8f43d97afc3e6f31dd670962ba4e015a2caab2760e2941352444056e4444f330"
  license "GPL-1.0-or-later"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    #sha256 arm64_big_sur: "4bd9658050af9172c3a8fc264b2fc72518346498e9388a4df00f91217942bfbf"
    #sha256 cellar: :any, big_sur:  "02cecf0a9071d8b965a8bd313dff23c0f8bb9c3b89ef1048a9d6a7972ce97f83"
    #sha256 cellar: :any, catalina: "1e390c7b3302b19e16d41853ee564daa6b9ad5022dd12592ce59cdd223bca60f"
    #sha256 cellar: :any, monterey: "d411279629c7183f72717fe60a66200f46eee6abc6e07c459a599f977d92e26d"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  resource "TalysDB" do
    url "https://github.com/vetlewi/Homebrew-formula/releases/download/v1.0/talysDB1.96.tar.gz"
    sha256 "d6da65baa463db0f9753ff1286bcde58e1cb22a238ae71cf3b976ee3f794ba7f"
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
