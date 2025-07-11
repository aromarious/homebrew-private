# 7/11/2025, 5:38:51 AM
class KeychainTools < Formula
  desc "macOSキーチェーン操作用CLIツール群"
  homepage "https://github.com/aromarious/keychain-tools"
  url "https://github.com/aromarious/keychain-tools/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3aa641f4978ee5296c80abcb5c907ac84d86980ed825376ca3adecbfe47bc67a"
  version "v1.2.0"
  license "MIT"

  def install
    ohai "Installing keychain-tools..."
    bin.install "kc-get", "kc-list", "kc-set", "kc-apps", "kc-dup"
  end

  test do
    # Test that commands exist and show proper error when APP_NAME is not set
    assert_match "Error: APP_NAME environment variable is not set", shell_output("#{bin}/kc-get 2>&1", 1)
    assert_match "Error: APP_NAME environment variable is not set", shell_output("#{bin}/kc-dup 2>&1", 1)
    
    # Test with APP_NAME set to show usage
    ENV["APP_NAME"] = "test-app"
    assert_match "Usage:", shell_output("#{bin}/kc-get 2>&1", 1)
    assert_match "Usage:", shell_output("#{bin}/kc-set 2>&1", 1)
    assert_match "Usage:", shell_output("#{bin}/kc-dup 2>&1", 1)
    
    # Test kc-apps (no APP_NAME required)
    system "#{bin}/kc-apps > /dev/null"
    
    # Test kc-list with argument
    system "#{bin}/kc-list test-app > /dev/null"
  end
end