# frozen_string_literal: true

RSpec.describe NetScanner do
  it "has a version number" do
    expect(NetScanner::VERSION).not_to be nil
  end
end

RSpec.describe NetScanner::CLI, type: :aruba do
  context "when help is provided" do
    it "shows help message" do
      run_command("net_scanner help")
      expect(last_command_started).to have_output(/Commands:/)
    end
  end

  context "when no command is provided" do
    it "prints error message when no network address is provided" do
      run_command("net_scanner netscan")
      expect(last_command_started).to have_output(/Please provide a network address./)
    end
  end

  context "when network address is provided" do
    let(:network_address) { "192.168.20.0/24" }
    let(:ip_address) { "192.168.20.1" }

    it "scans the network and prints the results" do
      run_command("net_scanner netscan #{network_address}")
      expect(last_command_started).to have_output("Scanning network #{network_address}......")
    end
  end
end
