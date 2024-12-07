class DisplayRotate < Formula
  desc "aaa-desc"
  homepage "https://aromarious"
  url "tar.gz"
  sha256 "asdfasdfasdf"
  version "v1.0.2"
  license "ISC"

  depends_on "node"
  depends_on "displayplacer"

  def install
    ohai "Installing display-rotate..."
    libexec.install "package.json", "package-lock.json", "bin", "dist"
    bin.install_symlink libexec/"bin/display-rotate"
  end

  test do
    system "#{bin}/display-rotate", "--version"
  end
end
