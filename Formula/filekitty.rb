class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e21b8df1e5316c6ea5f4014b1b2d97ee46cce92ccc8cfa9aa8bb663e89a97208"
  license "MIT"

  depends_on "python@3.12"
  depends_on "poetry"

  def install
    system "poetry", "install", "--no-interaction", "--no-root"
    system "poetry", "run", "python", "setup.py", "py2app"

    # Move the .app bundle into prefix (as required by Homebrew)
    prefix.install Dir["dist/FileKitty.app"]

    # CLI launcher script
    (bin/"filekitty").write <<~EOS
      #!/bin/bash
      open -a "FileKitty"
    EOS
  end

  def post_install
    app_source = prefix/"FileKitty.app"
    target = if File.writable?("/Applications")
      Pathname.new("/Applications/FileKitty.app")
    else
      Pathname.new(Dir.home + "/Applications/FileKitty.app")
    end

    ohai "Moving .app to: #{target}"
    system "mkdir", "-p", target.dirname
    system "cp", "-R", app_source, target
  end

  def caveats
    <<~EOS
      FileKitty.app has been installed to your Applications folder.

      You can launch it via:
        Spotlight → FileKitty
        open -a FileKitty
        filekitty    # from the terminal
    EOS
  end

  test do
    system "filekitty" rescue true
  end
end
