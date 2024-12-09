# 12/9/2024, 2:02:20 AM
class DisplayRotate < Formula
  desc "Rotate your display easily on macOS CLI using displayplacer."
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "778b2be4dbc5149c639576cf752b944508f5098142982beac6f6e54b3f7118df"
  version "v1.0.5"
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
