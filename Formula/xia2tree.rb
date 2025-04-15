class Xia2tree < Formula
    desc "XIA2tree: Toolkit for analysis of raw data from experiments with XIA Pixie-16 DGFs"
    homepage "https://github.com/vetlewi/XIA2tree"
    url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.5.tar.gz"
    version "0.9.5"
    sha256 "e04ab8f8ebbfd8e9dc1f6f348f7b384a9dfc52a0ef4701933b6d01a6b58cf55d"

    bottle do
        root_url "https://github.com/vetlewi/XIA2tree/releases/download/v0.9.5"
        sha256 cellar: :any, arm64_sonoma: "24062d613e7e903aa49117aaf62fd4bffc5c9a184dbc2ab315c8e8be63c299ca"
    end


    depends_on "cmake" => [:build, :test]
    depends_on "root"

    def install
        mkdir "XIA2tree-build" do
            args = std_cmake_args + %w[
                ../
                -DHOMEBREW_ALLOW_FETCHCONTENT=ON
            ]
            system "cmake", *args
            system "cmake", "--build", ".", "-j"
            system "cmake", "--install", "."
        end
    end
end


