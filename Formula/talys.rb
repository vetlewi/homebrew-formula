class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.0-4.tar.gz"
  version "2.0"
  sha256 "1c878aee255ed4b957ef8da0f31d7892052f0daa68b8489b9caae418da18acd3"
  license "MIT"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 arm64_sonoma: "6a7b93743e08aa20c46c823099598d47f0e0bce18b817eb2ea5575723da2614f"
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
