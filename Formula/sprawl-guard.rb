# Installs the prebuilt binary from the Sprawl Guard GitHub release for the user's platform.
class SprawlGuard < Formula
  desc "Keep source files short and directories small"
  homepage "https://kpozin.github.io/sprawl-guard/"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.6.0/sprawl-guard-0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "fa794d69666b6987d638402de474413338c73a46b66850e38ea729c0596da6f7"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.6.0/sprawl-guard-0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "b66cf256e33e3ad100aa21f70c74cba149d989523ca8e928261459519f7e5048"
    end
  end

  # The Linux builds need glibc 2.35 or newer, as in Ubuntu 22.04 and Debian 12.
  on_linux do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.6.0/sprawl-guard-0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d34c928af23380a113943b657c3a9f68d1a7e6490e2b7f1e8ff210cbf2c8e743"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.6.0/sprawl-guard-0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3ff7d4d312593c077b5f032a6ddd9c80d2dbc5d99fd65b51525357f8175fd27b"
    end
  end

  def install
    bin.install "sprawl-guard"
  end

  test do
    assert_match "sprawl-guard #{version}", shell_output("#{bin}/sprawl-guard --version")

    (testpath/"src/main.py").write "print('hello')\n"
    system bin/"sprawl-guard", "init", "--write"
    assert_path_exists testpath/"sprawl-guard.toml"
    assert_match "No sprawl-guard violations found.", shell_output("#{bin}/sprawl-guard check")

    (testpath/"src/large.py").write "x = 1\n" * 401
    assert_match "src/large.py: 401 lines (limit 400)", shell_output("#{bin}/sprawl-guard check", 1)
  end
end
