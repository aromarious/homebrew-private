# 12/8/2024, 11:59:54 AM
class DisplayRotate < Formula
  desc "Rotate your display easily on macOS CLI using displayplacer."
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "34144d661893472763dc48e617a1fe2ad4407a8aa1c68b1b2832bae7310f6118"
  version "v1.0.4"
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
