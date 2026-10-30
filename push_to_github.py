import os
import subprocess
import sys

REPO_URL = "https://github.com/friartscript/ORA-TANOA.git"

def run_cmd(cmd, check=True):
    print(f">> {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=False)
    if check and result.returncode != 0:
        print(f"[ERREUR] Échec de la commande : {' '.join(cmd)} (Code: {result.returncode})")
        return False
    return True

def main():
    root_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(root_dir)
    
    print("=" * 60)
    print("  LIAISON DU PROJET ARMA 3 A GITHUB : ORA-TANOA")
    print(f"  Dépôt : {REPO_URL}")
    print("=" * 60)
    
    if not os.path.exists(".git"):
        print("\n[1/5] Initialisation de Git...")
        if not run_cmd(["git", "init"]):
            return
    else:
        print("\n[1/5] Dépôt Git déjà initialisé.")

    print("\n[2/5] Configuration du remote et de la branche principale...")
    run_cmd(["git", "branch", "-M", "main"], check=False)
    run_cmd(["git", "remote", "remove", "origin"], check=False)
    if not run_cmd(["git", "remote", "add", "origin", REPO_URL]):
        return

    print("\n[3/5] Ajout des fichiers...")
    if not run_cmd(["git", "add", "."]):
        return

    print("\n[4/5] Création du commit...")
    run_cmd(["git", "commit", "-m", "Initial commit - Operation Royal Alliance (Tanoa)"], check=False)

    print("\n[5/5] Push vers GitHub...")
    success = run_cmd(["git", "push", "-u", "origin", "main"], check=False)

    print("=" * 60)
    if success:
        print("  [SUCCÈS] Projet lié et publié sur GitHub !")
        print(f"  {REPO_URL.replace('.git', '')}")
    else:
        print("  [INFO] Si l'authentification est requise, vérifiez vos identifiants GitHub.")
    print("=" * 60)

if __name__ == "__main__":
    main()
    input("\nAppuyez sur Entrée pour quitter...")

