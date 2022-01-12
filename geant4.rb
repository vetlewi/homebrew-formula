class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "http://cern.ch/geant4-data/releases/geant4-v11.0.0.tar.gz"
  version "11.0"
  sha256 "3cc8a7df9d3ff1c7a21a62d2eb3a10be15f6bb158d39323bf3213349c9ef75b9"

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    #sha256 cellar: :any, big_sur:  "a75cac9f3686b757ea668eecf3e75d873047b74492fe81ee3cc7bde5de209688"
    #sha256 cellar: :any, catalina: "7455d64767bdc04231c469521844190aa3bd9bfc96a534f5a3b93fda2c162563"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "expat"
  depends_on "qt@5"
  depends_on "xerces-c"

  # Check for updates in cmake/Modules/Geant4DatasetDefinitions.cmake

  resource "G4NDL" do
    url "https://cern.ch/geant4-data/datasets/G4NDL.4.6.tar.gz"
    sha256 "9d287cf2ae0fb887a2adce801ee74fb9be21b0d166dab49bcbee9408a5145408"
  end

  resource "G4EMLOW" do
    url "https://cern.ch/geant4-data/datasets/G4EMLOW.8.0.tar.gz"
    sha256 "d919a8e5838688257b9248a613910eb2a7633059e030c8b50c0a2c2ad9fd2b3b"
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
        -DCMAKE_PREFIX_PATH=Formula["qt@5"].opt_prefix
      ]

      #args << "-DQt5_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt5" if OS.mac?
      #args << "-DQt5Core_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt5Core" if OS.mac?
      #args << "-DQt5Gui_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt5Gui" if OS.mac?
      #args << "-DQt5Widgets_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt5Widgets" if OS.mac?
      #args << "-DQt5OpenGL_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt5OpenGL" if OS.mac?
      #args << "-DQt5PrintSupport_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt5PrintSupport" if OS.mac?
      #args << "-DQt53DCore_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt53DCore" if OS.mac?
      #args << "-DQt53DExtras_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt53DExtras" if OS.mac?
      #args << "-DQt53DRender_DIR=/usr/local/Cellar/qt@5/5.15.2/lib/cmake/Qt53DRender" if OS.mac?

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
      (share/"Geant4-#{version}/data/#{r.name}#{r.version}").install r
    end
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<~EOS
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    assert_match "Number of events processed : 1000",
                 shell_output("/bin/bash test.sh")
  end
end