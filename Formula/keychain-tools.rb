# 7/11/2025, 8:04:17 AM
class KeychainTools < Formula
  desc "macOSキーチェーン操作用CLIツール群"
  homepage "https://github.com/aromarious/keychain-tools"
  url "https://github.com/aromarious/keychain-tools/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a1e4e945fc0995a56deda626ace3543bad8fcc4d74919b75246c01eb5d8bcb58"
  version "v1.3.0"
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