class HookObservatory < Formula
  desc "Safety rails for AI coding assistants — smart hooks that watch, guard, and audit"
  homepage "https://github.com/operonlab/hook-observatory"
  url "https://github.com/operonlab/hook-observatory/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "aa1b2e6d6970c22defbc66ad3b9b7f718732d02eb7dadd7bfb260a14bee5c31b"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Install all source files to libexec
    libexec.install Dir["*"]

    # Create a wrapper script
    (bin/"hook-observatory").write <<~EOS
      #!/bin/bash
      exec "#{Formula["python@3.12"].opt_bin}/python3" "#{libexec}/install.py" "$@"
    EOS
  end

  def post_install
    ohai "Run 'hook-observatory' to register hooks into Claude Code"
    ohai "Run 'hook-observatory --uninstall' to remove them"
  end

  def caveats
    <<~EOS
      To install hooks into Claude Code:
        hook-observatory

      To uninstall:
        hook-observatory --uninstall

      To customize which handlers are enabled:
        #{HOMEBREW_PREFIX}/opt/hook-observatory/libexec/config.yaml
    EOS
  end

  test do
    assert_match "hook-observatory installer", shell_output("#{bin}/hook-observatory --help 2>&1", 0)
  end
end
