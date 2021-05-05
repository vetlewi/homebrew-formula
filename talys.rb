class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0/talys1.95.tar.gz"
  sha256 "4cadb8a35fb586efc6119470ffc185f8cf3ae2c2ed79e609b409515923f461ac"
  license "GPL-1.0-or-later"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 cellar: :any, big_sur:  "02cecf0a9071d8b965a8bd313dff23c0f8bb9c3b89ef1048a9d6a7972ce97f83"
    sha256 cellar: :any, catalina: "1e390c7b3302b19e16d41853ee564daa6b9ad5022dd12592ce59cdd223bca60f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  resource "TalysDB" do
    url "https://github.com/vetlewi/Homebrew-formula/releases/download/v1.0/talysDB1.95.tar.gz"
    sha256 "8a9308ea2b586abb65f0d43087ba01f8bb333837ed0e5438d6dc1ee66b85bfe1"
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
