# Waydroid

Waydroid has a great integration into linux, but it's sadly pretty annoying that all android applications will be added to `~/.local/share/applications` and thus create noise.

You can simply remove them by not displaying them by using following command:

```
ls -1 ~/.local/share/applications/waydroid.*.desktop | xargs rg --files-without-match 'NoDisplay' | xargs sed -i '/Desktop Action app_settings/iNoDisplay=true'
```

