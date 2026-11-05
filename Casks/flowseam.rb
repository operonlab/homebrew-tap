cask "flowseam" do
  version "0.1.0"
  sha256 "793bc1ad2165a4b25173443b4621ab15bd6dc2c92af87413609d51ab6f5159a7"

  url "https://github.com/operonlab/flowseam/releases/download/v#{version}/Flowseam-#{version}-macos.zip"
  name "Flowseam"
  desc "Share one keyboard, mouse, clipboard and files between Macs and Windows PCs"
  homepage "https://github.com/operonlab/flowseam"

  depends_on macos: ">= :ventura"

  app "Flowseam.app"

  # Signed with Flowseam's own certificate but not notarized: without this, Gatekeeper refuses to open the
  # downloaded app. The signature stays, and it is what keeps the privacy grants across updates.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Flowseam.app"]
  end

  uninstall quit: "com.operonlab.flowseam"

  caveats <<~EOS
    Open Flowseam once and grant Accessibility and Input Monitoring in
    System Settings > Privacy & Security. Updates keep these grants.
    Every machine must run the same Flowseam version.
  EOS
end
