class Pbrich < Formula
  desc "Like pbcopy, but with support for arbitrary pasteboard types"
  homepage "https://github.com/waynehoover/pbrich"
  url "https://github.com/waynehoover/pbrich/archive/v1.1.0.tar.gz"
  sha256 "57ec5bcdb7a8ee21700a9e76c3c9cefa7a045bfa0c1b785178e7dfd9d92649c8"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox",
           "--arch", "arm64", "--arch", "x86_64"
    bin.install ".build/apple/Products/Release/pbrich"
  end

  test do
    assert_match "1.1.0", shell_output("#{bin}/pbrich --version")
  end
end
