# UTF-8 encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Liaison & Synchronisation GitHub - ORA-TANOA"

$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoDir

$remoteUrl = "https://github.com/friartscript/ORA-TANOA.git"

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  LIAISON DU PROJET ARMA 3 A GITHUB : ORA-TANOA" -ForegroundColor Yellow
Write-Host "  Dossier : $repoDir" -ForegroundColor Gray
Write-Host "  Dépôt   : $remoteUrl" -ForegroundColor Gray
Write-Host "========================================================`n" -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[ERREUR] Git n'est pas installé ou absent du PATH Windows." -ForegroundColor Red
    Write-Host "Téléchargez-le sur https://git-scm.com/" -ForegroundColor Yellow
    Read-Host "Appuyez sur Entrée pour quitter..."
    exit 1
}

if (-not (Test-Path ".git")) {
    Write-Host "[1/5] Initialisation du dépôt Git local..." -ForegroundColor Green
    git init
} else {
    Write-Host "[1/5] Dépôt Git local déjà initialisé." -ForegroundColor Green
}

Write-Host "[2/5] Configuration du remote 'origin' et branche 'main'..." -ForegroundColor Green
git branch -M main
git remote remove origin 2>$null
git remote add origin $remoteUrl

Write-Host "[3/5] Ajout des fichiers au suivi Git..." -ForegroundColor Green
git add .

Write-Host "[4/5] Enregistrement du commit..." -ForegroundColor Green
$status = git status --porcelain
if ($status) {
    git commit -m "Initial commit - Operation Royal Alliance (Tanoa)"
} else {
    Write-Host "Aucune nouvelle modification à commiter." -ForegroundColor Gray
}

Write-Host "[5/5] Envoi (push) vers GitHub..." -ForegroundColor Green
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n========================================================" -ForegroundColor Cyan
    Write-Host "  [SUCCÈS] Projet lié et synchronisé avec succès !" -ForegroundColor Green
    Write-Host "  Lien : https://github.com/friartscript/ORA-TANOA" -ForegroundColor Yellow
    Write-Host "========================================================`n" -ForegroundColor Cyan
} else {
    Write-Host "`n[ERREUR] Le push a échoué (code sortie: $LASTEXITCODE)." -ForegroundColor Red
    Write-Host "Si GitHub refuse la connexion, vérifiez vos identifiants GitHub (Personal Access Token ou SSH)." -ForegroundColor Yellow
}

Read-Host "Appuyez sur Entrée pour quitter..."

