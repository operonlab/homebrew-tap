class HookObservatory < Formula
  desc "Go-native hook executor for Claude Code (formerly Python)"
  homepage "https://github.com/operonlab/hook-observatory"
  version "0.2.1"
  license "MIT"

  depends_on "jq" # install.sh manipulates ~/.claude/settings.json with jq

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-observatory-darwin-arm64"
      sha256 "6f6ea66f0de7c17fd5d95210b38585ce67a63df8de9a8828e525ca78001ed19f"
    else
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-observatory-darwin-amd64"
      sha256 "a0514a12c96748fa53c46b037ebebe69a05288470f47822b177f527aa4d2f8c3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-observatory-linux-arm64"
      sha256 "adba25170dd8592df4f452369452f2bf07b11234658950196a236db1db37c165"
    else
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.1/hook-observatory-linux-amd64"
      sha256 "b4a7e8cd80ecad7011ba71c88008f18d95f7551ce76f020b6859dcee96d246c5"
    end
  end

  def install
    # The release asset is a single binary file (no archive); rename and place.
    bin.install Dir["*"].first => "hook-observatory"
  end

  def caveats
    <<~EOS
      hook-observatory v0.2.1 ships a Go binary (replaces the Python dispatcher
      shipped in v0.1.0). v0.2.1 restores the MCP server interface dropped
      during the v0.2.0 rewrite — see `hook-observatory serve`.

      To register hooks into ~/.claude/settings.json, clone the source repo and
      run the installer script:

        git clone https://github.com/operonlab/hook-observatory.git
        cd hook-observatory
        ./install.sh --binary "#{bin}/hook-observatory"

      Or fetch install.sh directly:

        curl -fsSL https://raw.githubusercontent.com/operonlab/hook-observatory/main/install.sh -o /tmp/hook-install.sh
        bash /tmp/hook-install.sh --binary "#{bin}/hook-observatory"

      To remove:
        ./install.sh --uninstall

      If you previously had the Python version installed (v0.1.0),
      settings.json entries calling python3 dispatcher.py should be removed
      before installing this binary. The install.sh script handles this
      automatically.
    EOS
  end

  test do
    # hook-observatory reads JSON event on stdin; --help isn't supported, so the
    # binary's "no input" path is the test signal.
    assert_predicate bin/"hook-observatory", :exist?
    assert_predicate bin/"hook-observatory", :executable?

    # MCP server smoke test: handshake should respond on stdout.
    require "open3"
    init = <<~JSON.strip
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"brew-test","version":"0"}}}
    JSON
    out, _, _ = Open3.capture3(bin/"hook-observatory", "serve", stdin_data: init + "\n")
    assert_match(/"serverInfo"/, out)
    assert_match(/"hook-observatory"/, out)
  end
end
