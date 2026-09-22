# ReShade MFG + OptiScaler NR

> **Solución Modular y Unificada:** Multi-Frame Generation (hasta 4X) mediante ReShade Addon + DLSS 5 Neural Rendering (NR) multipass pre-SR mediante OptiScaler.

Validado en **Cyberpunk 2077** sobre arquitecturas **NVIDIA GeForce RTX 40 Series (Ada Lovelace)** sin pantallas negras, sin cierres inesperados y con sincronización completa de latencia (NVIDIA Reflex).

---

## 🎮 Controles en el Juego

| Tecla | Función | Descripción |
|---|---|---|
| **F11** | **Menú de OptiScaler** | Acceso a DLSS Neural Rendering (NR), selección de perfiles, multipass, estilos y upscalers (DLSS / FSR / XeSS). |
| **F10** | **Menú de ReShade** | Pestaña *Add-ons* → *MFG Unlock* para seleccionar el multiplicador de fotogramas (**2x, 3x, 4x**). |
| **+** (o `=`) | **Atajo rápido NR** | Activa/desactiva Neural Rendering al vuelo con confirmación en pantalla. |

---

## ⚡ Arquitectura del Kit

1. **`dxgi.dll` / `OptiScaler.dll`:**
   - Actúa como proxy DirectX 12 principal.
   - Ejecuta el pipeline de **DLSS Neural Rendering** (multipass pre-SR, reconstrucción neural de detalle, filtros OkLab y protección de piel).
   - Delega limpiamente el control de Frame Generation (`AdaMfgUnlock = false`) para evitar el error `0xBAD00005` (pantalla negra).
   - Invoca a ReShade en memoria mediante `LoadReshade = true`.
2. **`nvngx.dll_dlssnr.dll`:**
   - Forwarder open-source que vincula las llamadas de Neural Rendering con el runtime `nvngx_dlssnr.dll`.
3. **`ReShade64.dll` + `renodx-mfgunlock.addon64`:**
   - ReShade v6.8.0 con soporte oficial de Add-ons.
   - Addon MFG Unlock v1.0 (creado por Dreamt / mavismmg a partir de la investigación de dashdogy).
   - Realiza la inyección en memoria a `sl.interposer.dll` y `nvngx_dlssg.dll`, desbloqueando 3X y 4X en GPUs RTX 40 sin modificar archivos firmados en disco.

---

## 📦 Instalación Rápida

1. Cierra el juego si está en ejecución.
2. Ejecuta `install.bat` (o `install.ps1` en PowerShell).
3. Si el juego es *Cyberpunk 2077*, el script lo detectará automáticamente. De lo contrario, ingresa la ruta absoluta de la carpeta donde reside el ejecutable (`.exe`) del juego.
4. El script creará copias de respaldo (`.bak`) de tus archivos existentes y desplegará todo el paquete preconfigurado.
5. Inicia el juego:
   - Activa **Generación de fotogramas** en los ajustes gráficos del juego.
   - Presiona **F10** para fijar el multiplicador deseado (3x o 4x) en la pestaña *Add-ons*.
   - Presiona **F11** para ajustar los parámetros de Neural Rendering.

---

## 📋 Requisitos del Sistema

- **GPU:** NVIDIA GeForce RTX 40 Series (RTX 4050, 4060, 4070, 4080, 4090).
- **Controlador NVIDIA:** Driver 566.xx o superior.
- **HAGS:** Programación de GPU acelerada por hardware activada en Windows (`Configuración > Sistema > Pantalla > Gráficos`).
- **Runtime de DLSS-G:** Archivo `nvngx_dlssg.dll` versión 310.x presente en el juego.
- **Runtime de DLSS-NR:** Archivo `nvngx_dlssnr.dll` presente en la carpeta del juego (para funciones de Neural Rendering).

---

## Repository Structure

```text
reshade-mfg-optiscaler-nr/
├── components/                        # Modular component sources
│   ├── optiscaler/                    # OptiScaler proxy, core, and DLSS-NR forwarder
│   │   ├── dxgi.dll
│   │   ├── OptiScaler.dll
│   │   ├── OptiScaler.ini
│   │   └── nvngx.dll_dlssnr.dll
│   ├── reshade/                       # ReShade v6.8.0 and Multi-Frame Generation addon
│   │   ├── ReShade64.dll
│   │   ├── ReShade.ini
│   │   └── renodx-mfgunlock.addon64
│   └── backends/                      # Upscaler and Frame Generation support libraries
│       ├── amd_fidelityfx_*.dll       # AMD FidelityFX / FSR 3.1 FG
│       ├── libxess*.dll / libxell.dll # Intel XeSS and XeLL
│       └── dlssg_to_fsr3_*.dll
├── dist/                              # Assembled deployment package
│   ├── dxgi.dll                       # Root game proxy
│   ├── OptiScaler.dll
│   ├── OptiScaler.ini
│   ├── nvngx.dll_dlssnr.dll
│   ├── ReShade64.dll
│   ├── ReShade.ini
│   ├── renodx-mfgunlock.addon64
│   └── OptiScaler/                    # Canonical OptiDllPath directory for backends
│       ├── amd_fidelityfx_*.dll
│       └── libxess*.dll
├── docs/                              # Technical architecture and guides
│   └── ARCHITECTURE.md
├── scripts/                           # Tooling and installers
│   ├── build-dist.ps1                 # Assembles dist/ from components/
│   ├── install.bat                    # Batch deployment wizard
│   └── install.ps1                    # PowerShell deployment wizard
├── install.bat                        # Root convenience launcher
├── install.ps1                        # Root convenience launcher
├── .gitignore
└── README.md
```

