# Installs the prebuilt binary from the Sprawl Guard GitHub release for the user's platform.
class SprawlGuard < Formula
  desc "Keep source files short and directories small"
  homepage "https://kpozin.github.io/sprawl-guard/"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.0/sprawl-guard-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "a90f57edbb84bd0b3840cdb0fa4988bec219455ba607d0ded292f57628be7471"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.0/sprawl-guard-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "c264ebcc60c517656b32a73262bc0952596df835b3c6250b20193c97f91e33a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.0/sprawl-guard-0.5.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87f7ec3beb99408f895dac528db5d70ea2588bdd6d13b6c7ef7ad8588211a5c6"
    end
    # The static musl build runs on any Linux distribution, whatever its glibc version.
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.0/sprawl-guard-0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "42e4151e63581aaa1037065af4f2d9bba09c8defc7d6b95ad8cb7d1ffd730909"
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
