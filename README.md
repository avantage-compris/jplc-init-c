jplc-init-c
===========

### 1. Objectif

Réaliser en C le portage d’un programme simple écrit en FreeBASIC.

### 2. Fichiers de référence

Le programme original « FillCov » 
lit un fichier CSV comportant des données manquantes,
infère des valeurs pour ces données manquantes à partir des données présentes,
et émet deux fichiers CSV en sortie : le fichier complété avec les données
trouvées, et la matrice symétrique de covariance entre les colonnes de
données du fichier complété.

Fichiers CSV de référence :

  * UKOutput.csv : exemple de fichier en entrée
  * OupFillCov.csv : exemple de sortie, premier fichier
  * OupFillFile.csv : exemple de sortie, deuxième fichier

### 3. Utiliser git sur son poste

#### 3.1. Récupérer une première fois le repository git sur son poste

En ligne de commande :

    > git clone https://github.com/avantage-compris/jplc-init-c
    > cd jplc-init-c
    
#### 3.2. Enregistrer les modifications dans git sur son poste

Pour vérifier qu’il y a des modifications en cours :

    > git status

Pour voir le détail des modifications en cours :

    > git diff
    
Pour enregistrer les modifications dans git :

    > git commit -a -m 'Nouvel essai'

#### 3.3. Voir les dernières modifications enregistrées sur son poste

    > git log    
    commit xxx
    Author: David Andrianavalontsalama <david.andriana@avantage-compris.com>
    Date:   Tue Jul 26 06:50:33 2016 +0200

        Initial import: README + CSV test files + helloworld

#### 3.4. Voir le détail d’une modification (différences avant/après)

    > git show xxx

#### 3.5. Revenir à un état antérieur

    > git checkout xxx

#### 3.6. Revenir à l’état le plus récent

    > git checkout master

### 4. Utiliser C sur son poste

Rappel : placer les ficiers sources Java dans `src`

#### 4.1. Compiler un programme C

En ligne de commande :

    > gcc -o helloworld.exe src/helloworld.c

ou encore, pour plusieurs fichiers sources :

    > gcc -o cli2csv.exe src/cli2csv.c src/calcul.c src/io.c
    
#### 4.2. Exécuter un programme compilé

En ligne de commande UNIX :

    > ./helloworld.exe

En ligne de commande DOS :

    > helloworld.exe
    
