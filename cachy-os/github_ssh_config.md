# Configuración de SSH para GitHub

## Generar la llave SSH
Preguntará el nombpre, luego contraseña y confirmar. Dar enter para dejar todo por defecto (sin contraseña).

```fish
ssh-keygen -t ed25519 -C "tu-email@ejemplo.com"
```

## Agregar la clave pública a GitHub
Abrir el arhivo pub creado y copiarlo para pegarlo en github

```fish
cat ~/.ssh/id_ed25519.pub
```

## Ir a github [Github keys](https://github.com/settings/keys)
- Dar en agregar nuevo key
- Poner nombre
- Y en donde dice `key` pegar el contenido copiado.


## Clonar repositorio

```fish
git clone git@github.com:tu-usuario/tu-repositorio-privado.git
```
