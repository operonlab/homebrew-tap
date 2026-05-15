class HookObservatory < Formula
  desc "Go-native hook executor for Claude Code (formerly Python)"
  homepage "https://github.com/operonlab/hook-observatory"
  version "0.2.1"
  license "MIT"

  depends_on "jq" # install.sh manipulates ~/.claude/settings.json with jq

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-dispatcher-darwin-arm64"
      sha256 "b2d07164ae12c03b759624604b751ceb9f9f197a7f808591a6d497726a31a34c"
    else
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-dispatcher-darwin-amd64"
      sha256 "687b3f65e124a13d8876bc70dc694d530b5ab523f8a8f9c960386051b24f76e5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-dispatcher-linux-arm64"
      sha256 "1fdfe8875112530589feab65350986541073508c6c32b0e0fb973dbb4877cb45"
    else
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-dispatcher-linux-amd64"
      sha256 "ee1157bed3982b7129835eafe42b012456355fff17529916a07e45a54f8f05ab"
    end
  end

  def install
    # The release asset is a single binary file (no archive); rename and place.
    bin.install Dir["*"].first => "hook-dispatcher"
  end

  def caveats
    <<~EOS
      hook-observatory v0.2.1 ships a Go binary (replaces the Python dispatcher
      shipped in v0.1.0). v0.2.1 restores the MCP server interface dropped
      during the v0.2.0 rewrite — see `hook-dispatcher serve`.

      To register hooks into ~/.claude/settings.json, clone the source repo and
      run the installer script:

        git clone https://github.com/operonlab/hook-observatory.git
        cd hook-observatory
        ./install.sh --binary "#{bin}/hook-dispatcher"

      Or fetch install.sh directly:

        curl -fsSL https://raw.githubusercontent.com/operonlab/hook-observatory/main/install.sh -o /tmp/hook-install.sh
        bash /tmp/hook-install.sh --binary "#{bin}/hook-dispatcher"

      To remove:
        ./install.sh --uninstall

      If you previously had the Python version installed (v0.1.0),
      settings.json entries calling python3 dispatcher.py should be removed
      before installing this binary. The install.sh script handles this
      automatically.
    EOS
  end

  test do
    # hook-dispatcher reads JSON event on stdin; --help isn't supported, so the
    # binary's "no input" path is the test signal.
    assert_predicate bin/"hook-dispatcher", :exist?
    assert_predicate bin/"hook-dispatcher", :executable?

    # MCP server smoke test: handshake should respond on stdout.
    require "open3"
    init = <<~JSON.strip
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"brew-test","version":"0"}}}
    JSON
    out, _, _ = Open3.capture3(bin/"hook-dispatcher", "serve", stdin_data: init + "\n")
    assert_match(/"serverInfo"/, out)
    assert_match(/"hook-observatory"/, out)
  end
end
