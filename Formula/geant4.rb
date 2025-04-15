class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.3.1/geant4-v11.3.1.tar.bz2"
  sha256 "4bdefeb83bb84812430cc4e2165916aef099e89a332fa4a74ef7914216c71a50"

  depends_on "cmake" => [:build, :test]
  depends_on "expat"
  depends_on "qt"
  depends_on "xerces-c"

  # Check for updates in cmake/Modules/Geant4DatasetDefinitions.cmake

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.7.1.tar.gz"
    sha256 "d3acae48622118d2579de24a54d533fb2416bf0da9dd288f1724df1485a46c7c"
  end

  resource "G4EMLOW" do
    url "https://geant4-data.web.cern.ch/datasets/G4EMLOW.8.6.1.tar.gz"
    sha256 "4a93588d26080ce1d336b94f76fadabe4905fb8f1cba2415795023d6cd8f4a8a"
  end

  resource "PhotonEvaporation" do
    url "https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.6.1.tar.gz"
    sha256 "5ffc1f99a81d50c9020186d59874af73c53ba24c1842b3b82b3188223bb246f2"
  end

  resource "RadioactiveDecay" do
    url "https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.6.1.2.tar.gz"
    sha256 "Fa40d7e3ebc64d35555c4a49d0ff1e0945cd605d84354d053121293914caea13a"
  end

  resource "G4PARTICLEXS" do
    url "https://cern.ch/geant4-data/datasets/G4PARTICLEXS.4.1.tar.gz"
    sha256 "07ae1e048e9ac8e7f91f6696497dd55bd50ccc822d97af1a0b9e923212a6d7d1"
  end

  resource "G4PII" do
    url "https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "RealSurface" do
    url "https://cern.ch/geant4-data/datasets/G4RealSurface.2.2.tar.gz"
    sha256 "9954dee0012f5331267f783690e912e72db5bf52ea9babecd12ea22282176820"
  end

  resource "G4SAIDDATA" do
    url "https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz"
    sha256 "1d26a8e79baa71e44d5759b9f55a67e8b7ede31751316a9e9037d80090c72e91"
  end

  resource "G4ABLA" do
    url "https://cern.ch/geant4-data/datasets/G4ABLA.3.3.tar.gz"
    sha256 "1e041b3252ee9cef886d624f753e693303aa32d7e5ef3bba87b34f36d92ea2b1"
  end

  resource "G4INCL" do
    url "https://cern.ch/geant4-data/datasets/G4INCL.1.2.tar.gz"
    sha256 "f880b16073ee0a92d7494f3276a6d52d4de1d3677a0d4c7c58700396ed0e1a7e"
  end

  resource "G4ENSDFSTATE" do
    url "https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.3.0.tar.gz"
    sha256 "4bdc3bd40b31d43485bf4f87f055705e540a6557d64ed85c689c59c9a4eba7d6"
  end

  resource "G4CHANNELING" do
    url "https://cern.ch/geant4-data/datasets/G4CHANNELING.1.0.tar.gz"
    sha256 "203e3c69984ca09acd181a1d31a9b0efafad4bc12e6c608f0b05e695120d67f2"
  end

  resource "G4TENDL" do
    url "https://cern.ch/geant4-data/datasets/G4TENDL.1.4.tar.gz"
    sha256 "4b7274020cc8b4ed569b892ef18c2e088edcdb6b66f39d25585ccee25d9721e0"
  end

  resource "G4NUDEXLIB" do
    url "https://cern.ch/geant4-data/datasets/G4NUDEXLIB.1.0.tar.gz"
    sha256 "cac7d65e9c5af8edba2b2667d5822e16aaf99065c95f805e76de4cc86395f415"
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
