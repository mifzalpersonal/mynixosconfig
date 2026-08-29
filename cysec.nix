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
    gobuster
    nikto
    ffuf
    git-dumper
    macchanger
    tcpdump
    sage
  ];


  programs.wireshark.enable = true;
}