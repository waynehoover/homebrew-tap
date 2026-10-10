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
  version "0.13.0"
  license "MIT"

  # The Git export (docs/git-export.md) runs git, git-lfs and ssh. macOS has
  # git and ssh; git-lfs it does not.
  depends_on "git-lfs"
  uses_from_macos "git"

  on_macos do
    on_arm do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-darwin-arm64"
      sha256 "1e8212d27bbfdaabb16049cb61f5aa9b90ad4d858fb31b0e4755511c0f54b283" # trewd-darwin-arm64
    end
    on_intel do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-darwin-amd64"
      sha256 "3727d8e2ce0530c4cb9d637a79db3cb887292fbe507bae6fc1f3ba0e144611ea" # trewd-darwin-amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-linux-arm64"
      sha256 "0c4477d5e328cff13d32b9972219fa9dfed9c0606af66ac9844fb4efde9b6ac6" # trewd-linux-arm64
    end
    on_intel do
      url "https://github.com/waynehoover/trewsync/releases/download/server/v#{version}/trewd-linux-amd64"
      sha256 "c7c0db2ca174fa78d66771f5d900d6b7b9760fab4572d9af8e7ea995fbdacb84" # trewd-linux-amd64
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
