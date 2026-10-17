# typed: strict
# frozen_string_literal: true

# The TrewSync server, trewd, installed from its GitHub release.
#
# This file is the formula for the tap at github.com/waynehoover/homebrew-tap,
# where it lives as Formula/trewd.rb, so that
#
#   brew install waynehoover/tap/trewd
#
# works. The copy here is the source: it is rendered for each server release by
# scripts/homebrew-formula.sh from that release's published SHA256SUMS, and the
# rendered file is what is copied into the tap. Until the first server release
# it names version 0.0.0, which does not exist, and every sha256 below is a
# placeholder; `brew install` refuses it, which is the right answer.
#
# The binaries are the bare executables the release ships, trewd-<os>-<arch>,
# with nothing to unpack. `trewd update` leaves a Homebrew install alone and
# says to run `brew upgrade trewd`, because Homebrew keeps its own record of
# what it installed and would put the old binary back.
class Trewd < Formula
  desc "TrewSync server: self-hosted Obsidian vault sync with full version history"
  homepage "https://github.com/waynehoover/trewsync"
  version "0.14.0"
  license "MIT"

  # The Git export (docs/git-export.md) runs git, git-lfs and ssh. macOS has
  # git and ssh; git-lfs it does not.
  depends_on "git-lfs"
  uses_from_macos "git"

  on_macos do
    on_arm do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-darwin-arm64"
      sha256 "be483e6c773faee9b157306987a8973848dd851a2cd4ad6d7f9df1f6ad95cb25" # trewd-darwin-arm64
    end
    on_intel do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-darwin-amd64"
      sha256 "29e64d7a5843b5ba00de1da10887ffd47ee1baf5e08494e21e5903ba44354ec4" # trewd-darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-linux-arm64"
      sha256 "d94711b504b855e9d542f3fb3044c4195cc72eb2df7a6c4c5b225af6a5cb09d8" # trewd-linux-arm64
    end
    on_intel do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-linux-amd64"
      sha256 "798993ed06e56195171dbddda913f49195d325e6bc8f18dd4dd6f781da1e9909" # trewd-linux-amd64
    end
  end

  def install
    bin.install Dir["trewd-*"].first => "trewd"
  end

  def caveats
    <<~EOS
      The service below serves the vault in #{var}/trewd on 127.0.0.1:3003,
      without the MCP endpoint. Put TLS in front of it (tailscale serve, Caddy)
      before any device outside this machine connects. The first device's
      invite in #{var}/trewd/first-invite names this machine at port 3003, which
      no device behind TLS can use: make the first one with
      `trewd invite -data #{var}/trewd -url wss://NAME`, the name your devices reach.
    EOS
  end

  service do
    run [opt_bin/"trewd", "serve", "-data", var/"trewd", "-addr", "127.0.0.1:3003"]
    keep_alive true
    log_path var/"log/trewd.log"
    error_log_path var/"log/trewd.log"
  end

  test do
    assert_match "trewd #{version} ", shell_output("#{bin}/trewd version")
  end
end
