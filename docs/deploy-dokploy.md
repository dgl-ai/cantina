# Deploy Cantina en Dokploy — `worlds.dglabs.cloud`

## Arquitectura

```
GitHub (dgl-ai/cantina-web) → Dokploy build → Docker (nginx) → Traefik → worlds.dglabs.cloud
```

## Paso 1: Crear el proyecto en Dokploy

1. Abrir Dokploy dashboard (http://<vps-ip>:3000)
2. **Projects** → **Create Project** → Nombre: `DGLabs Worlds`
3. Dentro del proyecto → **Create Service** → **Docker**
   - Nombre: `cantina-web`
   - Repository: `https://github.com/dgl-ai/cantina-web`
   - Branch: `main`
   - Build Type: **Dockerfile**
   - Dockerfile Path: `./Dockerfile`
   - Context: `.` (root del repo)

## Paso 2: Dominio

1. En el servicio → **Advanced** → **Domains**
2. Add Domain:
   - Host: `worlds.dglabs.cloud`
   - Port: `80`
   - HTTPS: ✅ (Let's Encrypt automático via Traefik)

## Paso 3: DNS

En Cloudflare (o donde esté `dglabs.cloud`):
```
Type: CNAME
Name: worlds
Target: <vps-dglabs-cloud>
Proxy: DNS only (nube gris) — para que Traefik gestione TLS
```

## Paso 4: Deploy

1. **Save** la config del servicio en Dokploy
2. Click **Deploy** para el primer build
3. Verificar: `https://worlds.dglabs.cloud`

## Deploy continuo (opcional)

1. En Dokploy → servicio → **Advanced** → **Webhooks**
2. Copiar el webhook URL
3. En GitHub → repo `cantina-web` → **Settings** → **Webhooks** → Add
   - Payload URL: (la del webhook de Dokploy)
   - Content type: `application/json`
   - Events: **Just the push event**

Ahora cada `publish_web.sh` dispara deploy automático.

## Comandos útiles

```bash
# Deploy manual desde CLI
cd /root/projects/cantina && bash tools/publish_web.sh

# Verificar deploy
curl -sI https://worlds.dglabs.cloud | head -3

# Ver logs del contenedor
docker service logs cantina-web --tail 50
```

## Notas técnicas

- **MIME types**: nginx.conf ya configura `.wasm`, `.pck`, `.ogg` correctamente
- **Cache**: index.html sin cache, assets estáticos con cache 7d
- **Security headers**: X-Frame-Options, X-Content-Type-Options
- **Godot web export**: necesita COOP/COEP headers para SharedArrayBuffer (threads). Si se necesita:
  ```
  add_header Cross-Origin-Opener-Policy "same-origin" always;
  add_header Cross-Origin-Embedder-Policy "require-corp" always;
  ```
  (actualmente no se necesitan — single-threaded)
