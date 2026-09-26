# Configuración de SSH para GitHub

## Generar la llave SSH
```bash
# Preguntará el nombre, luego contraseña y confirmar. Dar enter para dejar todo por defecto (sin contraseña).
ssh-keygen -t ed25519 -C "khris.cmd@gmail.com"
```

## Agregar la clave pública a GitHub
```bash
# Abrir el arhivo pub creado y copiarlo para pegarlo en github
cat ~/.ssh/id_ed25519.pub
```

## Ir a github [Github keys](https://github.com/settings/keys)
- Dar en agregar nuevo key
- Poner nombre
- Y en donde dice `key` pegar el contenido copiado.


## Clonar repositorio

```bash
git clone git@github.com:tu-usuario/tu-repositorio-privado.git
```
