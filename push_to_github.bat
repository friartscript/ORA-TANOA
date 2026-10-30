@echo off
chcp 65001 >nul
title Liaison & Synchronisation GitHub - ORA-TANOA

echo ========================================================
echo   LIAISON DU PROJET ARMA 3 A GITHUB : ORA-TANOA
echo ========================================================
echo.

cd /d "%~dp0"

where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERREUR] Git n'est pas installe ou pas accessible dans le PATH.
    echo Veuillez installer Git pour Windows : https://git-scm.com/
    goto fin
)

if not exist ".git" (
    echo [1/5] Initialisation du depot Git local...
    git init
    if %ERRORLEVEL% neq 0 goto erreur
) else (
    echo [1/5] Depot Git deja initialise.
)

echo [2/5] Configuration du remote 'origin'...
git remote remove origin >nul 2>nul
git remote add origin https://github.com/friartscript/ORA-TANOA.git
git branch -M main

echo [3/5] Ajout des fichiers du projet...
git add .

echo [4/5] Creation du commit...
git commit -m "Initial commit - Operation Royal Alliance (Tanoa)" 2>nul
if %ERRORLEVEL% neq 0 (
    echo [INFO] Aucun nouveau changement a commiter ou commit deja effectue.
)

echo [5/5] Envoi vers GitHub (branche main)...
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   [SUCCES] Projet lie et synchronise sur GitHub !
    echo   https://github.com/friartscript/ORA-TANOA
    echo ========================================================
) else (
    goto erreur
)

goto fin

:erreur
echo.
echo ========================================================
echo   [ERREUR] Une erreur est survenue lors de l'operation.
echo   Si GitHub vous demande une authentification :
echo   - Utilisez un Personal Access Token (PAT) ou
echo   - Connectez-vous avec GitHub CLI (gh auth login)
echo ========================================================

:fin
echo.
pause

