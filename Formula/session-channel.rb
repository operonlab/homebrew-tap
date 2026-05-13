class SessionChannel < Formula
  desc "Cross-pane, cross-CLI pub-sub bus over tmux + Redis Streams"
  homepage "https://github.com/operonlab/session-channel"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/operonlab/session-channel/releases/download/v#{version}/session-channel-v#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "57a3bb8b2f1c37ef224e227f33e2f6ef5b37fc96efaa5bac846ae6079e5227f8"
    end
    on_intel do
      url "https://github.com/operonlab/session-channel/releases/download/v#{version}/session-channel-v#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "e28c4d32d063737ae721b010b0977d9047b35020fb702158968cdbb37e96807d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/operonlab/session-channel/releases/download/v#{version}/session-channel-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6b4911874e4e2c317285c07269b739af2f4c36d8ccce1140ca08cd8aaff983c0"
    end
    on_intel do
      url "https://github.com/operonlab/session-channel/releases/download/v#{version}/session-channel-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6861294c595befe003de178121e57de98ca674125ebc52df001a8be7a4c18c93"
    end
  end

  # Redis is recommended (the service needs one) but not required —
  # users may already run Redis via Docker, brew services, or a remote host.
  depends_on "redis" => :recommended

  def install
    bin.install "channel"
    bin.install "channel-service"
    # Tarballs from v0.2.0 onward ship LICENSE + README.md alongside the binaries.
    pkgshare.install "LICENSE" if File.exist?("LICENSE")
    pkgshare.install "README.md" if File.exist?("README.md")
  end

  # `brew services start session-channel` launches channel-service in the
  # background; logs go to var/log.
  service do
    run [opt_bin/"channel-service"]
    keep_alive true
    log_path var/"log/session-channel.log"
    error_log_path var/"log/session-channel.log"
  end

  test do
    assert_match "channel 0.", shell_output("#{bin}/channel --version")
    assert_match "channel-service 0.", shell_output("#{bin}/channel-service --version")
  end
end
