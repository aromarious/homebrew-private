# 12/8/2024, 10:49:08 PM
class TestProduct < Formula
  desc "test product decsciption"
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/releases/download/v1.0.0/display-rotate-1.0.2.tar.gz"
  sha256 "26e6597cff5eb6e98362e362b9ea0cc79c17be2d4685e6994a8b99f9fd755ae8"
  version "v1.0.2"
  license "ISC"

  depends_on "node"
  depends_on "displayplacer"

  def install
    ohai "Installing test-product..."
    libexec.install "package.json", "package-lock.json", "bin", "dist"
    bin.install_symlink libexec/"bin/test-product"
  end

  test do
    system "#{bin}/test-product", "--version"
  end
end
