
# Fichiers principaux

## Émetteurs
- `TX_optical_eml.m` : Émetteur avec laser modulé en externe (EML). Prend en entrée des symboles à transmettre, une période symbole et des paramètres du laser. Retourne le champ optique, la période d'échantillonnage et la puissance consommée.
- `TX_optical_dml.m` : Émetteur avec laser modulé directement (DML). Modélise un laser à semi-conducteur avec équations de taux simplifiées. Prend en entrée des symboles (courant), une période symbole et des paramètres du laser.

## Récepteur
- `RX_photodetector.m` : Photodétecteur pour la conversion optique-électrique. Convertit le champ optique en photocourant, ajoute du bruit thermique et modélise la bande passante électrique limitée.

## Canal de transmission
- `fiber.m` : Propagation dans la fibre optique avec atténuation et dispersion (ordres 2 et 3). Modélise les effets de la propagation sur le champ optique.
- `egalizateur.m` : Égaliseur pour compenser la dispersion chromatique de la fibre. Applique une fonction de transfert inverse à celle de la fibre.

## Création de composants
- `make_emlaser.m` : Création d'un laser modulé en externe avec paramètres configurables (modulation I ou I+Q, puissance optique, consommation).
- `make_laser_simple.m` : Création d'un laser simple pour modulation directe avec paramètres physiques (fréquence optique, indice de groupe, dimensions, réflectivités, etc.).
- `make_photodetector.m` : Création d'un photodétecteur avec paramètres configurables (sensibilité, bande passante électrique et optique, impédance, bruit thermique).
- `make_param_struct.m` : Utilitaire pour la création de structures de paramètres avec vérification des valeurs et contraintes.

## Simulations
- `Models.m` : Simulation d'un système par morceaux  à 10 Gb/s. Analyse le taux d'erreur binaire (BER) en fonction de la puissance optique.
- `model_equalizer.m` : Simulation avec égaliseur pour différents débits (2.5, 5 et 10 Gb/s). Compare les performances en termes de BER.
- `BER_Wf.m` : Calcul du BER en fonction de la puissance optique dans un système back-to-back (sans fibre) pour différents débits.
- `BER_with_fiber.m` : Calcul du BER avec propagation en fibre  pour différents débits et puissances optiques.
- `BER_with_fiber_direct.m` : Visualisation des signaux optiques et électriques avec modulation directe pour différentes couran de bias pour les distances propagation 0 & 20 km.

## Utilisation
Les scripts de simulation (Models.m, model_equalizer.m, BER_*.m) peuvent être exécutés directement pour visualiser les performances du système. Les autres fichiers sont des fonctions utilisées par ces scripts.
