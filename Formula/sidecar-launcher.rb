# 12/8/2024, 10:25:58 AM
class SidecarLauncher < Formula
  desc "A commandline tool to connect to a Sidecar capable device."
  homepage "https://github.com/Ocasio-J/SidecarLauncher"
  url "https://github.com/Ocasio-J/SidecarLauncher/releases/download/1.2/SidecarLauncher.zip"
  sha256 "fc3df81639f400aaff9b44ba20650cf56ef2f73a033b927bbe378cb3c73b9764"
  version "v1.2"
  license "unknown"

  def install
    ohai "Installing SidecarLauncher..."
    libexec.install "SidecarLauncer"
    bin.install_symlink libexec/"SidecarLauncher"
  end

  test do
    system "#{bin}/SidecarLauncher", "--version"
  end
end
