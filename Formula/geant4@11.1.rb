class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.1.2/geant4-v11.1.2.tar.gz"
  version "11.1.2" # NOTE see post-install when updating to newer versions
  sha256 "e9df8ad18c445d9213f028fd9537e174d6badb59d94bab4eeae32f665beb89af"

  #bottle do
  #  root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
  #  sha256 cellar: :any, monterey: "0e099d61f40aa3a186c68a93027de8c85b9f432982703c59dc3854ba615c7a54"
  #  sha256 cellar: :any, arm64_ventura: "e8a6ce9a65e3df8d2fffc5d92b77fdcf2d3af9b3c1e39491bcf2602df376f988"
  #end
  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 arm64_ventura: "a27d364d9816092c9e22fe369e01025e9f40766b5c8d40c73103e22ca437c201"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "expat"
  depends_on "qt@5"
  depends_on "xerces-c"

  # Check for updates in cmake/Modules/Geant4DatasetDefinitions.cmake

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.7.tar.gz"
    sha256 "7e7d3d2621102dc614f753ad928730a290d19660eed96304a9d24b453d670309"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.8.2.tar.gz"
    sha256 "3d7768264ff5a53bcb96087604bbe11c60b7fea90aaac8f7d1252183e1a8e427"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.5.7.tar.gz"
    sha256 "761e42e56ffdde3d9839f9f9d8102607c6b4c0329151ee518206f4ee9e77e7e5"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.5.6.tar.gz"
    sha256 "3886077c9c8e5a98783e6718e1c32567899eeb2dbb33e402d4476bc2fe4f0df1"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4PARTICLEXS" do
    url "https://cern.ch/geant4-data/datasets/G4PARTICLEXS.4.0.tar.gz"
    sha256 "9381039703c3f2b0fd36ab4999362a2c8b4ff9080c322f90b4e319281133ca95"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.1.tar.gz"
    sha256 "7698b052b58bf1b9886beacdbd6af607adc1e099fc730ab6b21cf7f090c027ed"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.0.tar.gz"
    sha256 "716161821ae9f3d0565fbf3c2cf34f4e02e3e519eb419a82236eef22c2c4367d"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.2.3.tar.gz"
    sha256 "9444c5e0820791abd3ccaace105b0e47790fadce286e11149834e79c4a8e9203"
  end

  resource "RealSurface" do
    url "https://cern.ch/geant4-data/datasets/G4RealSurface.2.2.tar.gz"
    sha256 "9954dee0012f5331267f783690e912e72db5bf52ea9babecd12ea22282176820"
  end

  resource "G4TENDL" do
    url "https://cern.ch/geant4-data/datasets/G4TENDL.1.4.tar.gz"
    sha256 "4b7274020cc8b4ed569b892ef18c2e088edcdb6b66f39d25585ccee25d9721e0"
  end

  def install
    mkdir "geant-build" do
      args = std_cmake_args + %w[
        ../
        -DGEANT4_USE_GDML=ON
        -DGEANT4_BUILD_MULTITHREADED=ON
        -DGEANT4_USE_QT=ON
        -DGEANT4_USE_SYSTEM_EXPAT=OFF
        -DCMAKE_PREFIX_PATH=Formula["qt@5"].opt_prefix
      ]

      system "cmake", *args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Because Geant4 expects a set of environment variables for
      datafiles, you should source:
        . #{HOMEBREW_PREFIX}/bin/geant4.sh (or .csh)
      before running an application built with Geant4.
    EOS
  end

  def post_install
    resources.each do |r|
      (share/"Geant4/data/#{r.name}#{r.version}").install r
    end
  end

  test do
    system "cmake", share/"Geant4/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    assert_match "Number of events processed : 1000",
                 shell_output("/bin/bash test.sh")
  end
end