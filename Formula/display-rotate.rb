# 12/16/2024, 6:56:17 AM
class DisplayRotate < Formula
  desc "Rotate your display easily on macOS CLI using displayplacer."
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b2b596b127be2eb7d4a36034941758e379ab33ce2b03f2a76f3ce533e88f1017"
  version "v1.1.0"
  license "ISC"

  depends_on "node"
  depends_on "displayplacer"

  def install
    ohai "Building display-rotate..."
    system "npm", "install"
    system "npm", "run", "build"
    ohai "Installing display-rotate..."
    libexec.install "package.json", "package-lock.json", "bin", "dist"
    bin.install_symlink libexec/"bin/display-rotate"
  end

  test do
    system "#{bin}/display-rotate", "--version"
  end
end
