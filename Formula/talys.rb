class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.2.tar.gz"
  sha256 "824adb072f9a2f7fc3cf5720533af9de0552e137d8ed7209916821a618dc44a8"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "gcc"

  resource "TalysDB" do
    url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0/talysDB2.22.tar.gz2"
    sha256 "6367a3d769be2ed3561e1f913f5c7c568f5c54ffe7802cb03b10f2df2cd4f2db"
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
end
