# 🤠 Cantina — Oficina Virtual Far West de los Bots DGLabs

Oficina virtual 2D pixel art estilo **gather.town**, ambientada como una cantina del Far West. Cada bot de DGLabs tiene su rol temático y su espacio de trabajo, con integración de IA (Hermes API + OpenRouter API).

## Stack

- **Godot 4.7** (GDScript)
- **TileMap** 32×32 px top-down
- **HTTPRequest** → Hermes API + OpenRouter API
- **Export web** para escritorio

## Estructura

```
cantina/
├── scenes/          # Escenas Godot (.tscn)
├── scripts/
│   ├── model/       # Datos y configuración
│   ├── view/        # UI y renderizado
│   └── controller/  # Lógica y APIs
├── assets/
│   ├── tilesets/    # Tileset de la cantina
│   ├── sprites/     # Personajes y objetos
│   ├── audio/       # Música y SFX
│   └── icons/       # Iconos y logos
├── data/            # bots.json (config de personajes)
├── tests/           # Tests automatizados
└── tools/           # Scripts de deploy y utilidades
```

## Bots de la cantina

| Bot | Rol | Zona |
|---|---|---|
| Maestro | Sheriff Mason | Junto a la puerta |
| Hermes | Hank el Tabernero | Detrás de la barra |
| Forge | Ferris el Herrero | Taller |
| Palette | Polly la Pianista | Piano |
| Pixel | Pixie la Dealer | Mesa de poker |
| Ferra | Dora la Establera | Establo |
| Hawkeye | Eagle Eye el Vigía | Mirador |

## Desarrollo

```bash
# Abrir en Godot
godot --path .

# Exportar web
godot --headless --path . --export-release "Web" build/web/index.html

# Ejecutar tests
godot --headless --path . --script tests/run_tests.gd
```

## Licencia

Proyecto interno DGLabs.
