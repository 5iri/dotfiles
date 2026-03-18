# SDDM Custom Login Screens (from Reddit)

These are SDDM login themes found from Reddit posts and linked GitHub repos.

## Sources

- Reddit: `[SDDM] A very customizable theme for you unsatisfied ricers.`
  - https://www.reddit.com/r/unixporn/comments/1lh3ssm/sddm_a_very_customizable_theme_for_you/
  - GitHub: https://github.com/uiriansan/SilentSDDM
- Reddit: `[sddm] Cozy themes for your login screen - sddm-astronaut-theme`
  - https://www.reddit.com/r/unixporn/comments/1hu5kpb/sddm_cozy_themes_for_your_login_screen/
  - GitHub: https://github.com/Keyitdev/sddm-astronaut-theme
- Reddit: `[OC] A YoRHa themed SDDM` (posted March 11, 2026)
  - https://www.reddit.com/r/unixporn/comments/1rqv4iu/oc_a_yorha_themed_sddm/
  - GitHub: https://github.com/NeekoKun/YoRHa-sddm-theme
- Reddit: `[SDDM] I made a xdm inspired SDDM theme with fancy animations`
  - https://www.reddit.com/r/unixporn/comments/hr4b1n/
  - GitHub: https://github.com/Zebreus/sddm-xdm-theme

## Files in this folder

- `conf.d/theme-silent.conf`
- `conf.d/theme-astronaut.conf`
- `conf.d/theme-yorha.conf`
- `conf.d/theme-xdm.conf`
- `conf.d/virtualkbd.conf`
- `install_and_apply.sh`

## Usage

1. Install one or more themes:
   ```bash
   cd ~/github/zshrc/sddm
   ./install_and_apply.sh --install all
   ```
2. Apply one theme:
   ```bash
   ./install_and_apply.sh --apply silent
   # options: silent | astronaut | yorha | xdm
   ```
3. Test before logout:
   ```bash
   sddm-greeter --test-mode --theme /usr/share/sddm/themes/silent
   ```

## Notes

- `silent` and `astronaut` use Qt6 + virtual keyboard settings.
- `theme-yorha.conf` and `theme-xdm.conf` assume the theme folder names:
  - `YoRHa-sddm-theme`
  - `sddm-xdm-theme`
- If any repo changes folder or metadata names, update the matching `Current=...` value.
