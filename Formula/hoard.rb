class Hoard < Formula
  desc "Disk-space map for macOS with a CLI and an MCP server for AI agents"
  homepage "https://github.com/operonlab/hoard"
  url "https://github.com/operonlab/hoard/releases/download/v0.6.0/hoard-v0.6.0-aarch64-apple-darwin.tar.gz"
  sha256 "cff0cfbc1cd2d1283596b2ed9b9a5753b09cd8a7cb321a1bb4961f21ac18b8f6"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "hoard"
  end

  def caveats
    <<~EOS
      The CLI scans what your account can read. For whole-disk scans, add your terminal app
      under System Settings > Privacy & Security > Full Disk Access.

      To let Claude Code use it as an MCP server:
        claude mcp add hoard -- hoard mcp

      The Hoard app (space map, uninstaller, protection UI) is on the Releases page:
        https://github.com/operonlab/hoard/releases
    EOS
  end

  test do
    assert_match "usage: hoard", shell_output("#{bin}/hoard 2>&1", 2)
  end
end
