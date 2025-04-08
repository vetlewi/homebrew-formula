class Xia2tree < Formula
    desc "XIA2tree: Toolkit for analysis of raw data from experiments with XIA Pixie-16 DGFs"
    homepage "https://github.com/vetlewi/XIA2tree"
    url "https://github.com/vetlewi/XIA2tree/archive/refs/tags/v0.9.2.tar.gz"
    version "0.9.2"
    sha256 "0f8ddee7a94de8bae0ac53f8e9e6f937c22465f0eea669b53d37babb8ef7abce"

    depends_on "cmake" => [:build, :test]
    depends_on "root"

    def install
        mkdir "XIA2tree-build" do
            buildargs = %w[
                --build
                -j
            ]
            system "cmake", "..", *std_cmake_args
            system "cmake", "--build", "-j"
            system "cmake", "--install"
        end
    end
end
