# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Talys < Formula
  desc "TALYS is an open source software package (GPL license) for the simulation of nuclear reactions"
  homepage "talys.eu"
  url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0/talys1.95.tar.gz"
  sha256 "14d1f30b9d2608071cab1ec5996e0221d82dabffb63f2dd27978f30a52cd7a07"
  license "GPL-1.0-or-later"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 cellar: :any, big_sur: "14c05bd10050ed88b3bc1b6d3351b4f09a932463756084e8830315ea8b79d78f"
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
    share.install "LICENSE"
    share.mkpath
  end

  def post_install
    (share/"talys/structure").install resource("TalysDB")
  end

end
