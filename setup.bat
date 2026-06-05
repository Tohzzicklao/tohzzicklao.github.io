@echo off
setlocal
echo ============================================
echo   GitHub Pages - tohzzicklao.github.io
echo ============================================
echo.

rem ---- 1. Verificar Git ----
git --version >nul 2>&1
if errorlevel 1 (
    echo [X] Git no esta instalado.
    echo     Descargalo de: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo [OK] Git detectado.

rem ---- 2. Verificar gh CLI ----
gh --version >nul 2>&1
if errorlevel 1 (
    echo [X] GitHub CLI gh no esta instalado.
    echo     Descargalo de: https://cli.github.com/
    pause
    exit /b 1
)
echo [OK] gh CLI detectado.

rem ---- 3. Verificar autenticacion ----
gh auth status >nul 2>&1
if errorlevel 1 (
    echo [*] Autenticando con GitHub...
    gh auth login --web --hostname github.com
    if errorlevel 1 (
        echo [X] Error en autenticacion.
        pause
        exit /b 1
    )
)
echo [OK] Autenticado en GitHub.

rem ---- 4. Ir al directorio del proyecto ----
cd /d "%~dp0"

rem ---- 5. Inicializar repo git local si falta ----
if not exist ".git" (
    echo [*] Inicializando repo local...
    git init
    git branch -M master
    git add .
    git commit -m "Initial commit: GitHub Pages landing page"
    echo [OK] Commit local creado.
) else (
    echo [*] Repo local ya existe.
    git rev-parse --verify HEAD >nul 2>&1
    if errorlevel 1 (
        echo [*] Creando commit inicial...
        git add .
        git commit -m "Initial commit: GitHub Pages landing page"
    )
)

rem ---- 6. Crear repo en GitHub y subir ----
echo [*] Creando repositorio en GitHub...
gh repo create tohzzicklao.github.io --public --source=. --remote=origin --push --description "GitHub Pages user site" >nul 2>&1
if errorlevel 1 (
    echo [*] El repo ya existe. Configurando remote...
    git remote remove origin 2>nul
    git remote add origin https://github.com/Tohzzicklao/tohzzicklao.github.io.git
    echo [*] Subiendo a GitHub...
    git push -u origin master 2>&1
    if errorlevel 1 (
        echo [X] Error al hacer push.
        echo     Revisa: https://github.com/Tohzzicklao/tohzzicklao.github.io
        pause
        exit /b 1
    )
)
echo [OK] Codigo subido a GitHub.

rem ---- 7. Habilitar GitHub Pages ----
echo [*] Habilitando GitHub Pages...
gh api /repos/Tohzzicklao/tohzzicklao.github.io/pages -X POST -f "source[branch]=master" -f "source[path]=/" >nul 2>&1
if errorlevel 1 (
    echo [*] No se pudo habilitar Pages via API.
    echo     Habilitalo manualmente en:
    echo     https://github.com/Tohzzicklao/tohzzicklao.github.io/settings/pages
    echo     Source: Deploy from branch ^> master ^> / (root) ^> Save
) else (
    echo [OK] GitHub Pages habilitado.
)

echo.
echo ============================================
echo   Listo. Visita tu sitio en:
echo   https://tohzzicklao.github.io
echo ============================================
pause
endlocal
