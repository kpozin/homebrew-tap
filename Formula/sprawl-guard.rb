# Installs the prebuilt binary from the Sprawl Guard GitHub release for the user's platform.
class SprawlGuard < Formula
  desc "Keep source files short and directories small"
  homepage "https://kpozin.github.io/sprawl-guard/"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.2/sprawl-guard-0.5.2-aarch64-apple-darwin.tar.gz"
      sha256 "3ca8486c3246b9036d697ace279fd73e2d3c90d2275a0ea6bc391b4867adf538"
    end
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.2/sprawl-guard-0.5.2-x86_64-apple-darwin.tar.gz"
      sha256 "fd09042ab982ddf4beedacb4379c0e3eebc0dbfc42e88cca3b98060f6e68b622"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.2/sprawl-guard-0.5.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "78975d4720be25c38ba5032dd9124c837a42c4a1d70c2ec4381b162b5e4c3c0a"
    end
    # The static musl build runs on any Linux distribution, whatever its glibc version.
    on_intel do
      url "https://github.com/kpozin/sprawl-guard/releases/download/v0.5.2/sprawl-guard-0.5.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f2682386b1575f44df09f188d709a5575dc9f6671004b4a39495428d78e5f462"
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
