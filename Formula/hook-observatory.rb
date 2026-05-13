class HookObservatory < Formula
  desc "Go-native hook executor for Claude Code (formerly Python)"
  homepage "https://github.com/operonlab/hook-observatory"
  version "0.2.0"
  license "MIT"

  depends_on "jq" # install.sh manipulates ~/.claude/settings.json with jq

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.0/hook-dispatcher-darwin-arm64"
      sha256 "0e7d2f20bba1e008f25242051a4b9683fbe1990482c0717fdec87166bdf16014"
    else
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.0/hook-dispatcher-darwin-amd64"
      sha256 "ca2c735c53c9465d43893ea987e9daa245809639ddef0032f41718be177484a2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.0/hook-dispatcher-linux-arm64"
      sha256 "7d81fed93bb3501a9a08269c41120d6889ca013fa5ecc4a5195fa48635f0ba0a"
    else
      url "https://github.com/operonlab/hook-observatory/releases/download/v0.2.0/hook-dispatcher-linux-amd64"
      sha256 "db83b9b42475a15555842dc4d7b5a86d94b4a7783ee6580cc1f59f5fc7ba2c75"
    end
  end

  def install
    # The release asset is a single binary file (no archive); rename and place.
    bin.install Dir["*"].first => "hook-dispatcher"
  end

  def caveats
    <<~EOS
      hook-observatory v0.2.0 is now a Go binary (replaces the Python dispatcher
      shipped in v0.1.0).

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
  end
end
