class TmuxWebui < Formula
  desc "Web UI for tmux — your panes in any browser, with PWA + LAN/QR access"
  homepage "https://github.com/operonlab/tmux-webui"
  version "0.1.0"
  license "MIT"

  depends_on "tmux"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/tmux-webui/releases/download/v0.1.0/tmux-webui_0.1.0_darwin_arm64.tar.gz"
      sha256 "f5bf474549f2b76eb7c5caf1c094f966601be6297041d07cbb6c8df08ec8271e"
    else
      url "https://github.com/operonlab/tmux-webui/releases/download/v0.1.0/tmux-webui_0.1.0_darwin_amd64.tar.gz"
      sha256 "7a2724340f32ced91c76e8a20b9676641ca780dacd9fb78ae35dbdfec957c3ba"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/tmux-webui/releases/download/v0.1.0/tmux-webui_0.1.0_linux_arm64.tar.gz"
      sha256 "55dfd374b44dc348c94818d898b385f6ef1178dcd078a263cacd9d18f7aeb89e"
    else
      url "https://github.com/operonlab/tmux-webui/releases/download/v0.1.0/tmux-webui_0.1.0_linux_amd64.tar.gz"
      sha256 "271cc945dd4d781acc61271e3b616e35e65bd59bf134ae55004ee441adfa75a1"
    end
  end

  def install
    bin.install "tmux-webui"
  end

  def caveats
    <<~EOS
      Start the server (opens http://localhost:9527):
        tmux-webui

      From your phone (prints a QR code + token URL):
        tmux-webui --lan

      Run as a login service (launchd on macOS, systemd on Linux):
        tmux-webui daemon install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmux-webui version")
  end
end
