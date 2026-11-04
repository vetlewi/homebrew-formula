class Talys < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v2.2.tar.gz"
  sha256 "824adb072f9a2f7fc3cf5720533af9de0552e137d8ed7209916821a618dc44a8"
  license "MIT"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/vetlewi/formula"
    sha256                               arm64_tahoe:   "eba103a125ec4214503d89022301ddbf7fd44dd845fe8adc2011c10c1a1cf46f"
    sha256                               arm64_sequoia: "fc2c3734a09e59c7c68eae2f53eec8e5adfa4fd5207427a41764fcb041920316"
    sha256                               arm64_sonoma:  "8bf2e384d011719228920d4ebd179bf64e3c3d3b40bfce8c0831473258808754"
    sha256 cellar: :any,                 sequoia:       "5bdc06c32d75a8f35656c258d392f6a7bc6167013affe937eeec30f08a34bcea"
    sha256                               arm64_linux:   "d07a964bf076851f6cc31d2507eed7e6ecfab274c34687863223ce02e212d341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23dbf1a89e578c74fa093ca192f02dcf949dc3eed19bfc6955d4e66b6d6bc14"
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  def install
    system "cmake", "-S", ".", "-B", "talys_build", *std_cmake_args
    system "cmake", "--build", "talys_build"
    system "cmake", "--install", "talys_build"
    pkgshare.install "LICENSE"
    pkgshare.install "test/simple.txt"
  end

  # The structure database is downloaded after install so it is not baked into the bottle.
  post_install_steps do
    unless_path_exists "structure", base: :pkgshare do
      run "/bin/sh", network_access: true, writable_paths: ["structure"], writable_base: :pkgshare,
                     args: ["-c", <<~SH, "sh", "{{pkgshare}}"]
                       set -eu
                       url="https://nds.iaea.org/talys/misc/structure.tar"
                       sha256="ad2f9b356c391bd615c19d493cc241b47a6c51d0bf77e283cb59661f4ee78568"
                       tmp="$(mktemp -d)"
                       trap 'rm -rf "$tmp"' EXIT
                       curl -fL --retry 3 -o "$tmp/db.tar" "$url"
                       if command -v sha256sum >/dev/null 2>&1; then
                         actual="$(sha256sum "$tmp/db.tar")"
                       else
                         actual="$(shasum -a 256 "$tmp/db.tar")"
                       fi
                       [ "${actual%% *}" = "$sha256" ] || { echo "sha256 mismatch for $url" >&2; exit 1; }
                       tar -xf "$tmp/db.tar" -C "$tmp"
                       mv "$tmp/structure" "$1/structure"
                     SH
    end
  end

  test do
    assert_predicate bin/"talys", :executable?
  end
end
