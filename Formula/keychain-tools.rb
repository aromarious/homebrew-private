# 7/1/2025, 6:26:48 AM
class KeychainTools < Formula
  desc "macOSキーチェーン操作用CLIツール群"
  homepage "https://github.com/aromarious/keychain-tools"
  url "https://github.com/aromarious/keychain-tools/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "454d12ff60dcbb0e1f30fba3895192ef69c8a154bd0f3b3ae1e1ad6bb14934a4"
  version "v1.0.0"
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