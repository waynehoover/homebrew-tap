class Pbrich < Formula
  desc "Like pbcopy, but with support for arbitrary pasteboard types"
  homepage "https://github.com/waynehoover/pbrich"
  url "https://github.com/waynehoover/pbrich/archive/v1.0.0.tar.gz"
  sha256 "9e97c060bd8b45b446e2567f403f036c786d49cfe2e9fe4fa630e44d1f96bac2"
  license "MIT"

  depends_on :macos
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox",
           "--arch", "arm64", "--arch", "x86_64"
    bin.install ".build/apple/Products/Release/pbrich"
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/pbrich --version")
  end
end
