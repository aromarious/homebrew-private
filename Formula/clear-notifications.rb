# 12/14/2024, 8:43:26 AM
class ClearNotifications < Formula
  desc "Clears all notifications."
  homepage "https://github.com/aromarious/clear-notifications"
  url "https://github.com/aromarious/clear-notifications/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "d20c26cd286f6747702fe61abbe7f7db76337e67267f16a01fd603647e881a82"
  version "v1.0.3"
  license "ISC"

  def install
    ohai "Installing clear-notifications..."
    libexec.install "clear-notifications"
    libexec.install "clear-notifications.applescript"
    bin.install_symlink libexec/"clear-notifications"
  end

  test do
    system "#{bin}/clear-notifications", "--version"
  end
end
