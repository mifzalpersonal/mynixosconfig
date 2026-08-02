{ pkgs, ... }:

let
  # Buat script init untuk session labwc kamu
  labwcWinboatScript = pkgs.writeShellScriptBin "labwc-winboat-session" ''
    # Ekspor environment variable Wayland yang penting
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=wlroots

    # Jalankan daemon pendukung jika perlu (misal mako untuk notifikasi)
    # ${pkgs.mako}/bin/mako &

    # Jalankan labwc
    exec ${pkgs.labwc}/bin/labwc
  '';

  # Buat file .desktop session Wayland-nya agar muncul di Ly
  labwcWinboatSession = pkgs.writeTextDir "share/wayland-sessions/labwc-winboat.desktop" ''
    [Desktop Entry]
    Name=Labwc WinBoat
    Comment=Minimalist Wayland Environment for WinBoat
    Exec=${labwcWinboatScript}/bin/labwc-winboat-session
    Type=Application
  '';
in
{
  # Pastikan paket-paket pendukungnya terinstal di sistem
  environment.systemPackages = with pkgs; [
    labwc
    foot          # Terminal ringan berbasis Wayland untuk troubleshooting
    feh           # Kalau butuh set wallpaper
    # winboat     # (Opsional: pasang jika sudah ada di channel nixpkgs atau via overlay/appimage)
  ];

  # Daftarkan session custom ke Display Manager
  services.displayManager.sessionPackages = [ labwcWinboatSession ];

  # Aktifkan Ly
  services.displayManager.ly.enable = true;
}