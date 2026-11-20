# Installs the prebuilt binary from the Sprawl Guard GitHub release for the user's platform.
class SprawlGuard < Formula
  desc "Keep source files short and directories small"
  homepage "https://kpozin.github.io/sprawl-guard/"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.7.0/sprawl-guard-0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "1384dbcd0e649b68be6296354cc6b306428b0d81693ec0249c923a607a8b67d3"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.7.0/sprawl-guard-0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "fc087d03418dedf7e066d919015f5cf1b08341c84f41896c754cd599f465c761"
    end
  end

  # The Linux builds need glibc 2.35 or newer, as in Ubuntu 22.04 and Debian 12.
  on_linux do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.7.0/sprawl-guard-0.7.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f0bf336b2b44ce7f6c37a902bbe120bf8567fca70d099b12c1bc737b0ada792"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.7.0/sprawl-guard-0.7.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2e4fa4f7e110e5519a85269249e6330887dbe59f4ce01bb2dba23b8ffef437a3"
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
