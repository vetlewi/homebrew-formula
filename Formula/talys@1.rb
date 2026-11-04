class TalysAT1 < Formula
  desc "Open source software package for the simulation of nuclear reactions"
  homepage "http://talys.eu"
  url "https://github.com/oslocyclotronlab/Talys-code/archive/refs/tags/v1.96TfKeyword.tar.gz"
  sha256 "8397e9e7c3d5595bf6e0afe3b10dc114dd65b627b2717187f21242b551799f98"
  license "GPL-1.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/vetlewi/homebrew-formula/releases/download/v1.0"
    sha256 cellar: :any, arm64_sonoma: "89c49722d3ba42a849ff0cbcb2f5433d8b176b71a45765ed0cf6328d65f57f03"
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
                       url="https://github.com/vetlewi/Homebrew-formula/releases/download/v1.0/talysDB1.96.tar.gz"
                       sha256="d6da65baa463db0f9753ff1286bcde58e1cb22a238ae71cf3b976ee3f794ba7f"
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
    assert_match "The TALYS team congratulates you with this successful calculation.",
      shell_output("#{bin}/talys < #{pkgshare}/simple.txt")
  end
end
