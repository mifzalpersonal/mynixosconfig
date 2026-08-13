# /etc/nixos/cysec.nix
{ pkgs, ... }:

{
environment.systemPackages = with pkgs; [   
    nmap
    masscan
    wireshark
    netcat
    sqlmap
    nikto
    john
    hashcat
    hydra
    ghidra
    metasploit
    ngrok
    burpsuite
    arp-scan
    aircrack-ng
  ];


  programs.wireshark.enable = true;
}