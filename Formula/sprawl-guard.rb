# Installs the prebuilt binary from the Sprawl Guard GitHub release for the user's platform.
class SprawlGuard < Formula
  desc "Keep source files short and directories small"
  homepage "https://kpozin.github.io/sprawl-guard/"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.3/sprawl-guard-0.5.3-aarch64-apple-darwin.tar.gz"
      sha256 "0c2bd2395514133e13ad1d93ba2449ab1bef5d7973ae58e5884d62335ce13301"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.3/sprawl-guard-0.5.3-x86_64-apple-darwin.tar.gz"
      sha256 "8dec3e2b1cc665627cb3ec2bb41bbe6185385ddc86cf1e9794da84ef92cf5c1a"
    end
  end

  # The Linux builds need glibc 2.35 or newer, as in Ubuntu 22.04 and Debian 12.
  on_linux do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.3/sprawl-guard-0.5.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0e8a8e940b8e2a99c85ea53cba561fac4f3d34d2a1963aff5670f51fda0d615a"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.3/sprawl-guard-0.5.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b08951ea62199d524f41cd60677ffb63f2b848d4e789d86c0c461a403f1c38b6"
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
