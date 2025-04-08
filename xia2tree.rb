class Xia2tree < Formula
    desc "XIA2tree: Toolkit for analysis of raw data from experiments with XIA Pixie-16 DGFs"
    homepage "https://github.com/vetlewi/XIA2tree"
    url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.3.tar.gz"
    version "0.9.3"
    sha256 "18b13933abd196147a96e512661e8ff029ef77ef197bbe11b1d9e28da991bcfe"

    depends_on "cmake" => [:build, :test]
    depends_on "root"

    def install
        mkdir "XIA2tree-build" do
            args = std_cmake_args + %w[
                ../
                -DHOMEBREW_ALLOW_FETCHCONTENT=ON
            ]
            system "cmake", *args
            system "cmake", "--build", "-j"
            system "cmake", "--install"
        end
    end
end
