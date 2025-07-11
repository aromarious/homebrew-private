# 7/11/2025, 4:48:45 AM
class KeychainTools < Formula
  desc "macOSキーチェーン操作用CLIツール群"
  homepage "https://github.com/aromarious/keychain-tools"
  url "https://github.com/aromarious/keychain-tools/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ceed4b508033e655f3c1d38f289c093385341c2bfefc5b30e766ded58395a11"
  version "v1.1.0"
  license "MIT"

  def install
    ohai "Installing keychain-tools..."
    bin.install "kc-get", "kc-list", "kc-set"
  end

  test do
    # Test that commands exist and show proper error when APP_NAME is not set
    assert_match "Error: APP_NAME environment variable is not set", shell_output("#{bin}/kc-get 2>&1", 1)
    assert_match "Error: APP_NAME environment variable is not set", shell_output("#{bin}/kc-list 2>&1", 1)
    
    # Test with APP_NAME set to show usage
    ENV["APP_NAME"] = "test-app"
    assert_match "Usage:", shell_output("#{bin}/kc-get 2>&1", 1)
    assert_match "Usage:", shell_output("#{bin}/kc-set 2>&1", 1)
  end
end