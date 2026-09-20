for app in $(flatpak list --app --columns=application); do
  flatpak --user override "$app" \
    --filesystem=~/.icons/:ro \
    --filesystem=/usr/share/icons/:ro \
    --filesystem=~/.themes/:ro \
    --filesystem=/usr/share/themes/:ro \
    --filesystem=~/.fonts/:ro \
    --filesystem=/usr/share/fonts/:ro \
    --env=GTK_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d \')
done
