class DisplayRotate < Formula
  desc "Rotate your display easily via command-line on macOS using displayplacer."
  homepage "https://github.com/aromarious/{{ formula }}"
  url {{ url}}
  sha256 "26e6597cff5eb6e98362e362b9ea0cc79c17be2d4685e6994a8b99f9fd755ae8"
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
