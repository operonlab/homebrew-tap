cask "flowseam" do
  version "0.1.3"
  sha256 "7f98108df316a6bede8ec36e2297ad9d25995d1df3fb9c2a83e57f15b53b995b"

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

  caveats <<~EOS
    Open Flowseam once and grant Accessibility and Input Monitoring in
    System Settings > Privacy & Security. Updates keep these grants.
    Every machine must run the same Flowseam version.
  EOS
end
