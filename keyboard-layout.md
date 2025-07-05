# MacBook Pro 2015 Keyboard Layout on Arch Linux

## Physical Keyboard Detection
This MacBook Pro 12,1 (13-inch, Early 2015) has a **Swedish physical keyboard layout**.

### How to Identify Physical Layout
Test by typing these keys:
- Right of L key: Swedish=`ö`, US/UK=`;`
- Right of P key: Swedish=`å`, US=`[`, UK=`[`
- Shift+3: Swedish=`#`, US=`#`, UK=`£`
- Shift+2: Swedish=`"`, US=`@`, UK=`"`

Swedish keyboards have dedicated `å`, `ä`, and `ö` keys.

## Current Configuration
- **Physical keyboard**: Swedish
- **Hyprland**: Swedish (se) and UK Mac (gb(mac)) with Alt+Space switching
- **System-wide**: Swedish (se)

## Keyboard Layout in Different Environments

### Wayland (Hyprland)
Configured in `~/.config/hypr/hyprland.conf` (or in your dotfiles at `~/dotfiles-arch/hypr/hyprland.conf`):
```toml
# This must come AFTER sourcing omarchy defaults to override them
input {
    kb_layout = se,gb(mac)
    kb_options = compose:caps,grp:alt_space_toggle
}
```

**Important**: The input block must be placed AFTER all `source` statements in the config file, otherwise omarchy defaults will override your settings.

Change temporarily:
```bash
hyprctl keyword input:kb_layout se
```

Switch between layouts:
- **Alt+Space** - Toggle between Swedish and UK layouts
- Check active layout: `hyprctl devices | grep "active keymap" | head -1`

### System-wide Configuration
Stored in `/etc/vconsole.conf`:
```
KEYMAP=sv-latin1
XKBLAYOUT=se
```

Update with:
```bash
sudo localectl set-x11-keymap se
```

### Check Current Layout
```bash
# Wayland session type
echo $XDG_SESSION_TYPE

# System configuration
localectl status

# X11 (won't work properly in Wayland)
setxkbmap -query
```

## Swedish Keyboard Special Characters

### Using Right Alt (AltGr)
- `@` = Right Alt + 2
- `£` = Right Alt + 3
- `$` = Right Alt + 4
- `€` = Right Alt + E
- `{` = Right Alt + 7
- `[` = Right Alt + 8
- `]` = Right Alt + 9
- `}` = Right Alt + 0
- `\` = Right Alt + Plus
- `|` = Right Alt + <key right of Shift>

### Direct Keys
- `å` = dedicated key right of P
- `ä` = dedicated key right of Å
- `ö` = dedicated key right of L
- `<` = key left of Z
- `>` = Shift + <
- `'` = key right of Ä
- `*` = Shift + '

## Terminal (Alacritty) Configuration
Some key combinations might conflict with terminal shortcuts. For Alacritty, you can add to `~/.config/alacritty/alacritty.toml`:
```toml
option_as_alt = "OnlyLeft"
```

This allows the right Option/Alt key to function as AltGr for special characters.

## Multiple Layouts
Multiple layouts are configured in Hyprland using comma-separated values:
```toml
input {
    kb_layout = se,gb(mac)
    kb_options = compose:caps,grp:alt_space_toggle
}
```

**Note**: For Mac variants, use parenthesis syntax like `gb(mac)` rather than colon syntax like `gb:mac`.

### Layout Switching
- **Alt+Space** - Toggle between layouts
- Test which layout is active by pressing the key right of L:
  - `ö` = Swedish layout
  - `;` = UK layout

## Troubleshooting

### Wrong Characters Appearing
1. Check physical layout matches software layout
2. In Wayland, `setxkbmap` won't work - use Hyprland config
3. Some applications might use Xwayland and behave differently

### Special Characters Not Working
1. Use Right Alt (AltGr), not Left Alt
2. Check terminal emulator isn't capturing the key combo
3. Verify layout with `hyprctl keyword input:kb_layout`

### Application-Specific Issues
- **VSCode**: Should follow system layout
- **Chrome/Chromium**: Use `--ozone-platform=wayland` for proper Wayland support
- **X11 apps**: Might need `localectl` system configuration