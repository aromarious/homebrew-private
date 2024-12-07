class DisplayRotate < Formula
  desc "Rotate your display easily on macOS CLI using displayplacer."
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/archive/refs/tags/20241207-1428.tar.gz"
  sha256 "fbefb05f081c3f5bf3251c28058be6485e553ac402f346718e014f3fd04f9a0e"
  version "20241207-1428"
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
