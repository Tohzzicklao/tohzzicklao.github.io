@echo off
echo ============================================
echo   GitHub Pages - tohzzicklao.github.io
echo ============================================
echo.

:: Check if gh CLI is installed
where gh >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [!] GitHub CLI (gh) no esta instalado.
    echo     Instalando...
    winget install --id GitHub.cli
    if %ERRORLEVEL% NEQ 0 (
        echo [X] Error. Instala manualmente: https://cli.github.com/
        pause
        exit /b 1
    )
)

:: Check if logged in
gh auth status >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [!] Autenticando con GitHub...
    gh auth login --web --hostname github.com
    if %ERRORLEVEL% NEQ 0 (
        echo [X] Error en autenticacion.
        pause
        exit /b 1
    )
)

:: Create repo on GitHub
echo [*] Creando repositorio en GitHub...
gh repo create tohzzicklao.github.io --public --description "GitHub Pages user site"

:: Add remote and push
cd /d "C:\Users\janic\proyectos_IA\tohzzicklao.github.io"
git remote add origin https://github.com/Tohzzicklao/tohzzicklao.github.io.git
git push -u origin main

:: Enable GitHub Pages
echo [*] Habilitando GitHub Pages (puede tardar ~1 min)...
gh api repos/Tohzzicklao/tohzzicklao.github.io/pages -X POST -f "source[branch]=main" -f "source[path]=/" >nul 2>nul

echo.
echo ============================================
echo [OK] Listo! Visita tu sitio en:
echo     https://tohzzicklao.github.io
echo ============================================
pause
