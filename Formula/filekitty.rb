class Filekitty < Formula
  desc "A local LLM prompt toolkit with a macOS GUI"
  homepage "https://github.com/banagale/FileKitty"
  url "https://github.com/banagale/FileKitty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e21b8df1e5316c6ea5f4014b1b2d97ee46cce92ccc8cfa9aa8bb663e89a97208"
  license "MIT"

  depends_on "python@3.12"
  depends_on "poetry"

  def install
    ENV["PYTHON"] = Formula["python@3.12"].opt_bin/"python3"

    # Create virtualenv and install deps
    system "poetry", "install", "--no-interaction", "--no-root"

    # Build macOS .app
    system "poetry", "run", "python", "setup.py", "py2app"

    # Install app bundle to Homebrew prefix
    prefix.install Dir["dist/FileKitty.app"]
  end

  def caveats
    <<~EOS
      FileKitty.app has been installed to:
        #{opt_prefix}/FileKitty.app

      You can move it to /Applications:
        mv #{opt_prefix}/FileKitty.app /Applications/

      Or launch it directly:
        open #{opt_prefix}/FileKitty.app
    EOS
  end

  test do
    system "true"
  end
end

