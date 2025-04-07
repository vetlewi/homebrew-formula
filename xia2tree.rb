class XIA2tree < Formula
    desc "Toolkit for analysis of raw data from experiments with XIA Pixie-16 DGFs"
    homepage "https://github.com/vetlewi/XIA2tree"
    url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.0.tar.gz"
    version "0.9.0"
    sha256 "f5836405f69e10696714b9f6b82def29159e18f1bfb8cfe571d13bf3552691c5"

    depends_on "cmake" => [:build, :test]
    depends_on "root"

    def install
        mkdir "XIA2tree-build" do
            buildargs = %w[
                --build
                -j
            ]
            system "cmake", *std_cmake_args
            system "cmake", "--build", "-j"
            system "cmake", "--install"
        end
    end
end
