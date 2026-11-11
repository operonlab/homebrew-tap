cask "flowseam" do
  version "0.1.4"
  sha256 "4cb9f4bc256407ffd14fb05437b8bbbb0a64ebd5d42dc816c11366a5459ef960"

  url "https://github.com/operonlab/flowseam/releases/download/v#{version}/Flowseam-#{version}-macos.zip"
  name "Flowseam"
  desc "Share one keyboard, mouse, clipboard and files between Macs and Windows PCs"
  homepage "https://github.com/operonlab/flowseam"

  depends_on macos: :ventura

  app "Flowseam.app"

  # Signed with Flowseam's own certificate but not notarized: without this, Gatekeeper refuses to open the
  # downloaded app. The signature stays, and it is what keeps the privacy grants across updates.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Flowseam.app"]
  end

  uninstall quit: "com.operonlab.flowseam"

  # The settings, this machine's identity and its pairings: after a zap, every computer pairs again.
  zap trash: [
    "~/.config/flowseam",
    "~/Library/Application Support/flowseam",
    "~/Library/Caches/Flowseam",
    "~/Library/Logs/Flowseam",
    "~/Library/Preferences/com.operonlab.flowseam.plist",
  ]

  caveats <<~EOS
    Open Flowseam once and grant Accessibility and Input Monitoring in
    System Settings > Privacy & Security. Updates keep these grants.
    Every machine must run the same Flowseam version.
  EOS
end
