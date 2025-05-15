class TalysAT1 < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v1.96.tar.gz"
  sha256 "56b23e28e3dab6542f642e641119675e7ed1c40487a033383b2ce503581be378"
  license "GPL-1.0-or-later"

  depends_on "cmake" => :build
  depends_on "gcc"

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
