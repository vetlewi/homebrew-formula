class Geant4AT112 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.2.0/geant4-v11.2.0.tar.bz2"
  version "11.2.0" # NOTE: see post-install when updating to newer versions
  sha256 "1a9e7eeb79519156c10adb04aa9c22316ff2df800dbb58727cbf649b7787a15e"

  depends_on "cmake" => [:build, :test]
  depends_on "expat"
  depends_on "qt"
  depends_on "xerces-c"

  # Check for updates in cmake/Modules/Geant4DatasetDefinitions.cmake

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.7.tar.gz"
    sha256 "7e7d3d2621102dc614f753ad928730a290d19660eed96304a9d24b453d670309"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.8.5.tar.gz"
    sha256 "66baca49ac5d45e2ac10c125b4fb266225e511803e66981909ce9cd3e9bcef73"
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
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.3.tar.gz"
    sha256 "1e041b3252ee9cef886d624f753e693303aa32d7e5ef3bba87b34f36d92ea2b1"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.2.tar.gz"
    sha256 "f880b16073ee0a92d7494f3276a6d52d4de1d3677a0d4c7c58700396ed0e1a7e"
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
        -DGEANT4_USE_QT_QT6=ON
        -DGEANT4_USE_SYSTEM_EXPAT=OFF
        -DCMAKE_PREFIX_PATH=Formula["qt"].opt_prefix
      ]

      system "cmake", *args
      system "make", "install", "-j10"
    end
  end

  def post_install
    resources.each do |r|
      (share/"Geant4/data/#{r.name}#{r.version}").install r
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
