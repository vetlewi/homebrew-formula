class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0/talys1.95.tar.gz"
  sha256 "4cadb8a35fb586efc6119470ffc185f8cf3ae2c2ed79e609b409515923f461ac"
  license "GPL-1.0-or-later"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 cellar: :any, big_sur:  "14c05bd10050ed88b3bc1b6d3351b4f09a932463756084e8830315ea8b79d78f"
    sha256 cellar: :any, catalina: "f407da9a8fd0161b6de36f37a9b6ab08f5f677265a36cc3c24d3d5cf37063ae3"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  def install
    mkdir "talys_build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "LICENSE"
    pkgshare.install "test/simple.txt"
  end

  resource "TalysDB" do
    url "https://github.com/vetlewi/Homebrew-formula/releases/download/v1.0/talysDB1.95.tar.gz"
    sha256 "8a9308ea2b586abb65f0d43087ba01f8bb333837ed0e5438d6dc1ee66b85bfe1"
  end

  def post_install
    (pkgshare/"structure").install resource("TalysDB")
  end

  test do
    assert_match "The TALYS team congratulates you with this successful calculation.", shell_output("#{bin}/talys < #{pkgshare}/simple.txt")
  end

end
