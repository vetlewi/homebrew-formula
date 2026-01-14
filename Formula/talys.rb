class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.2.tar.gz"
  sha256 "824adb072f9a2f7fc3cf5720533af9de0552e137d8ed7209916821a618dc44a8"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc"

  resource "TalysDB" do
    url "https://nds.iaea.org/talys/misc/structure.tar"
    sha256 "ad2f9b356c391bd615c19d493cc241b47a6c51d0bf77e283cb59661f4ee78568"
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
