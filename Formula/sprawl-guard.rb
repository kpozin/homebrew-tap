class SprawlGuard < Formula
  desc "Keep source files short and directories small"
  homepage "https://kpozin.github.io/sprawl-guard/"
  url "https://github.com/kpozin/sprawl-guard/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ec1266afd2da406e05e799a9862f50abbe8af7015027cc337564815b00860d88"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/kpozin/sprawl-guard.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sprawl-guard")
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
