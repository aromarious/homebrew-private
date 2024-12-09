# 12/9/2024, 12:16:31 AM
class TestProduct < Formula
  desc "test product decsciption"
  homepage "https://github.com/aromarious/display-rotate"
  url "https://github.com/aromarious/display-rotate/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "34144d661893472763dc48e617a1fe2ad4407a8aa1c68b1b2832bae7310f6118"
  version "v1.0.4"
  license "ISC"

  depends_on "node"
  depends_on "displayplacer"

  def install
    ohai "Installing test-product..."
    libexec.install "package.json", "package-lock.json", "bin", "dist"
    Dir.chdir(libexec) do
      mv "bin/display-rotate", "bin/test-product"
    end
    bin.install_symlink libexec/"bin/test-product"
  end

  test do
    system "#{bin}/test-product", "--version"
  end
end
