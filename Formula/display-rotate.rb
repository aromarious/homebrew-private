class DisplayRotate < Formula
  desc "Rotate your display easily on macOS CLI using displayplacer."
  homepage "https://github.com/aromarious/{{ formula }}"
  url {{ url}}
  sha256 "d69acb4dec4fa6beb3a78fc042ecdc5ec71840e5cf44c708bd71e6e40c132330"
  version "20241207-1130"
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
