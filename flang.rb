class Flang < Formula
  desc "Fortran front end for LLVM"
  homepage "https://flang.llvm.org"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.4/flang-16.0.4.src.tar.xz"
  version "16.0.4"
  sha256 "fb941edf5a023e9c27f889cc216784b4c264bd7b80f32ea2961728e24c0a656b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  option "with-ninja", "Build with `ninja` instead of `make`"
  option "without-flang-new", "Disable the new Flang driver"

  depends_on "cmake" => :build
  depends_on "ninja" => :build if build.with?("ninja")
  depends_on "bash" # `flang` script uses `local -n`
  depends_on "gcc" # for gfortran
  depends_on "llvm"
  uses_from_macos "zlib"

  # We need to compile with Homebrew GCC 11.
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"
  fails_with gcc: "9"
  fails_with gcc: "10"

  def llvm
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
  end

  def install
    llvm_cmake_lib = llvm.opt_lib/"cmake"
    args = %W[
      -DLLVM_DIR=#{llvm_cmake_lib}/llvm
      -DMLIR_DIR=#{llvm_cmake_lib}/mlir
      -DCLANG_DIR=#{llvm_cmake_lib}/clang
      -DFLANG_BUILD_NEW_DRIVER=#{build.with?("flang-new") ? "ON" : "OFF"}
      -DFLANG_INCLUDE_TESTS=OFF
      -DLLVM_ENABLE_ZLIB=ON
    ]

    source = build.head? ? "flang" : "flang-#{version}.src"
    cmake_generator = build.with?("ninja") ? "Ninja" : "Unix Makefiles"
    system "cmake", "-G", cmake_generator,
                    "-S", ".", "-B", "build",
                    *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"omptest.f90").write <<~EOS
      PROGRAM omptest
      USE omp_lib
      !$OMP PARALLEL NUM_THREADS(4)
      WRITE(*,'(A,I1,A,I1)') 'Hello from thread ', OMP_GET_THREAD_NUM(), ', nthreads ', OMP_GET_NUM_THREADS()
      !$OMP END PARALLEL
      ENDPROGRAM
    EOS

    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS

    system bin/"flang", "-fopenmp", "omptest.f90", "-o", "omptest"
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.f90").write <<~EOS
      PROGRAM test
        WRITE(*,'(A)') 'Hello World!'
      ENDPROGRAM
    EOS

    system bin/"flang", "test.f90", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp
  end
end