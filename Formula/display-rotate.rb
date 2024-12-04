class DisplayRotate < Formula
  desc "Rotate your display easily via command-line on macOS using displayplacer."
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/archive/refs/tags/v1.0.2.tar.gz”
  sha256 "26e6597cff5eb6e98362e362b9ea0cc79c17be2d4685e6994a8b99f9fd755ae8"
  license "ISC"

  depends_on "node"
  depends_on "displayplacer"
  depends_on "jq"

  def install
    system "npm", "install"
    system "npm", "run", "build"
    libexec.install "package.json", "package-lock.json", "bin", "dist"
    bin.install_symlink libexec/"bin/display-rotate"
  end

  test do
    # Add a test command here
    system "#{bin}/display-rotate", "--version"
  end
end
