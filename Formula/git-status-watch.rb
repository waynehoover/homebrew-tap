class GitStatusWatch < Formula
  desc "Reactive git status watcher using native filesystem events"
  homepage "https://github.com/waynehoover/git-status-watch"
  url "https://github.com/waynehoover/git-status-watch/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "390cb5bba5468aea75938118afdf44662ac721448924981c094b9bc04ac94e40"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "git-status-watch", shell_output("#{bin}/git-status-watch --help")
  end
end
