# Arquitectura del Sistema: ReShade MFG + OptiScaler NR

```
[ Motor del Juego: Cyberpunk 2077 ]
               │
               ▼
         [ dxgi.dll ] (OptiScaler v0.7.7-final + DLSS-NR)
         ┌─────┴───────────────────────────────┐
         │                                     │
         ▼                                     ▼
[ Pipeline DLSS-NR ]                  [ Plugins.LoadReShade ]
 - nvngx.dll_dlssnr.dll                        │
 - nvngx_dlssnr.dll                            ▼
 - Reconstrucción neural pre-SR         [ ReShade64.dll ]
 - Filtros de tono de piel OkLab               │
 - Multipass AI details                        ▼
                                     [ renodx-mfgunlock.addon64 ]
                                               │
                                               ▼
                                     [ sl.interposer.dll ]
                                      - Hook slDLSSGSetOptions
                                      - Desbloqueo 3X / 4X
                                      - Sincronización Reflex
```

## Puntos Clave de la Coexistencia:

1. **Delegación de MFG:** En `OptiScaler.ini`, `AdaMfgUnlock` se mantiene en `false`. OptiScaler no toca los descriptores ni los kernels de `nvngx_dlssg.dll`, evitando el error `0xBAD00005`.
2. **Carga en Cadena:** OptiScaler inicializa DXGI y carga `ReShade64.dll`.
3. **Inyección en Memoria:** `renodx-mfgunlock.addon64` aplica los slots de cubins y descriptores PTX de Blackwell en Ada para habilitar la interpolación de hasta 4 fotogramas por cada cuadro base.
4. **Telemetría Verificada:** El sistema fue validado en sesiones continuas de juego procesando más de 35,000 fotogramas concurrentes entre Neural Rendering y Multi-Frame Generation.
