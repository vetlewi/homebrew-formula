class Xia2tree < Formula
    desc "XIA2tree: Toolkit for analysis of raw data from experiments with XIA Pixie-16 DGFs"
    homepage "https://github.com/vetlewi/XIA2tree"
    url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.3.tar.gz"
    version "0.9.3"
    sha256 "18b13933abd196147a96e512661e8ff029ef77ef197bbe11b1d9e28da991bcfe"

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
