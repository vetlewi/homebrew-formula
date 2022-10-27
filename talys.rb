class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v1.96TfKeyword.tar.gz"
  version "1.96"
  sha256 "8397e9e7c3d5595bf6e0afe3b10dc114dd65b627b2717187f21242b551799f98"
  license "GPL-1.0-or-later"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 cellar: :any, monterey: "d86c547341f0f4b09c8120315409e2779a66defdb37a8cc3380a0a04354c08b9"
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
