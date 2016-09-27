# frozen_string_literal: true
module Sanscript
  module_function

  # Attempts to load Rust native extension.
  # @return [bool] whether the extension loaded.
  def load_rust!
    return RUST_AVAILABLE if defined?(RUST_AVAILABLE)
    require "thermite/fiddle"
    Thermite::Fiddle.load_module("init_rusty_sanscript",
                                 cargo_project_path: GEM_ROOT,
                                 ruby_project_path: GEM_ROOT)
    #:nocov:#
    true
  rescue Fiddle::DLError
    false
    #:nocov:#
  end

  # @return [bool] the enabled status of the Rust extension
  def rust_enabled?
    @rust_enabled
  end

  # Turns on Rust extension, if available.
  # @return [bool] the enabled status of the Rust extension
  def rust_enable!
    if RUST_AVAILABLE
      Detect.module_eval do
        class << self
          alias_method :detect_scheme, :rust_detect_scheme
        end
      end
      @rust_enabled = true
    end
    @rust_enabled
  end

  # Turns off Rust native extension.
  # @return [bool] the enabled status of the Rust extension
  def rust_disable!
    Detect.module_eval do
      class << self
        alias_method :detect_scheme, :ruby_detect_scheme
      end
    end
    @rust_enabled = false
  end
end
