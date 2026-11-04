class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "https://geant4.web.cern.ch"
  url "https://gitlab.cern.ch/geant4/geant4/-/archive/v11.4.2/geant4-v11.4.2.tar.bz2"
  sha256 "868b364fc5cabd10e3dc997c62991150d967e026c01bdbe25a9b7b01a1de99d6"

  depends_on "cmake" => [:build, :test]
  depends_on "expat"
  depends_on "qtbase"
  depends_on "xerces-c"

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %w[
      -DGEANT4_USE_GDML=ON
      -DGEANT4_BUILD_MULTITHREADED=ON
      -DGEANT4_USE_QT=ON
      -DGEANT4_USE_QT_QT6=ON
      -DGEANT4_USE_SYSTEM_EXPAT=OFF
    ]

    system "cmake", "-S", ".", "-B", "geant-build", *args, *std_cmake_args
    system "cmake", "--build", "geant-build"
    system "cmake", "--install", "geant-build"
  end

  # Datasets are downloaded after install so they are not baked into the bottle.
  post_install_steps do
    run "geant4-config", base: :bin, args: ["--install-datasets"], network_access: true,
                        writable_paths: ["Geant4/data"], writable_base: :share
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
