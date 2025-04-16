class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.0-4.tar.gz"
  version "2.0"
  sha256 "1c878aee255ed4b957ef8da0f31d7892052f0daa68b8489b9caae418da18acd3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    rebuild 1
    sha256                               arm64_sequoia: "4edc7ee711771e86eaa5bc257b2b5f0bd952738b5c81b87b0c66fb75d4a278df"
    sha256                               arm64_sonoma:  "f734dcb3d301905b065ac09aec291e8392cfd95f64c841acc6ea5f7b3f36feec"
    sha256 cellar: :any,                 ventura:       "f40cbe992349c6936556342f5b5e9023d7359b74f6c5ebbd8d3b395bd0631aaa"
    sha256                               arm64_linux:   "080cefbd48128f5f41728512a662074c4e5b93e4e7bd5bb3d935f6356358cc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5e3fe9c45a384457c9b180df8461306470ccd69802cbc844733d996a1f5b62"
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  resource "TalysDB" do
    url "https://nds.iaea.org/talys/misc/structure.tar"
    sha256 "c155a0c4692fd9f68daa259a080a9786eab251ecb198188c9e8c3fb51c89fb43"
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
