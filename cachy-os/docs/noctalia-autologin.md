## Activar autologin en CachyOS Noctalia

```bash
cat /etc/greetd/config.toml
```
Agregar al final
```toml
[initial_session]
command = "uwsm start hyprland-uwsm.desktop"
user = "cristian"
```
