# TELECOM_PROJ

Ce dépôt contient un ensemble de projets et de simulations liés aux télécommunications, principalement implémentés en MATLAB. Il couvre divers aspects de la modélisation de canaux, de la performance des systèmes de communication optique et de l'analyse de signaux.

## Structure du dépôt

Le dépôt est organisé en plusieurs répertoires, chacun correspondant à une partie spécifique du projet ou à un module d'étude.

### `D1`

Ce répertoire contient des scripts MATLAB pour des fonctions de base en traitement du signal et en communication, telles que :

*   `ask_mod.m`, `fsk_mod.m`, `psk_mod.m` : Fonctions de modulation ASK, FSK et PSK.
*   `demod.m` : Fonction de démodulation générique.
*   `gen_signal.m` : Génération de signaux.
*   `matched_filter.m` : Implémentation d'un filtre adapté.
*   `QAM_mod.m`, `QAM_demod.m` : Fonctions de modulation et démodulation QAM.
*   `signal_gen.m` : Génération de signaux divers.

### `D2`

Ce répertoire est dédié à la modélisation de canaux et à l'analyse de la performance. Il inclut :

*   **`subblocks/channelModel/QuaDriGa_2019.06.27_v2.2.0`** : Intégration du modèle de canal QuaDRiGa, un simulateur de canal radio pour les systèmes de communication sans fil. Ce sous-répertoire contient des scripts pour la configuration, la génération de pistes (tracks), et des tutoriels pour l'utilisation de QuaDRiGa.
    *   `quadriga_src` : Le code source de QuaDRiGa, avec des configurations de canaux (`config/*.conf`) et des scripts de tutoriel (`tutorials/*.m`).
*   **`subblocks/signal_analysis_and_performance_function`** : Scripts pour l'analyse spectrale et l'estimation de performance.
    *   `perf_estim.m`, `plot_spectrum.m`, `simple_plot_spectrum.m`, `simple_raw_spectrum.m`.

### `D3`

Ce module se concentre sur les systèmes de communication optique, avec des simulations de la fibre optique et des composants optoélectroniques. Il contient :

*   `BER_Wf.m`, `BER_with_fiber.m`, `BER_with_fiber_direct.m` : Calcul du taux d'erreur binaire (BER) avec et sans fibre optique.
*   `egalizateur.m` : Implémentation d'un égaliseur.
*   `fiber.m`, `fiber_PMDCF.m`, `fiber_o.m` : Modèles de fibre optique.
*   `make_emlaser.m`, `make_laser_simple.m`, `make_photodetector.m` : Fonctions pour modéliser des lasers et des photodétecteurs.
*   `model.m`, `model_band_O.m`, `model_equalizer.m` : Modèles de système optique.
*   `RX_photodetector.m`, `TX_optical_dml.m`, `TX_optical_eml.m` : Modèles de récepteur et d'émetteur optique.
*   `D3.pdf` : Un document PDF qui pourrait contenir des explications ou des résultats liés à ce module.

### `D4`

Ce répertoire contient des scripts pour l'analyse de performance, notamment :

*   `d4_perfs_students.m`, `rejection_per_debits.m` : Scripts pour évaluer les performances en fonction des débits.
*   `D4.pdf` : Un document PDF qui pourrait contenir des explications ou des résultats liés à ce module.

### `ref`

Ce répertoire contient des références ou des exemples, comme le sous-répertoire `git-homework` avec des scripts MATLAB pour le calcul et l'affichage de l'ensemble de Mandelbrot (`mandelbrot_calc.m`, `mandelbrot_display.m`).

## Utilisation

Pour utiliser les scripts, naviguez dans le répertoire du module souhaité et exécutez les fichiers `.m` correspondants dans un environnement MATLAB. Les fichiers PDF (`D3.pdf`, `D4.pdf`) peuvent fournir des informations supplémentaires sur les objectifs et les résultats des simulations.

## Contribution

Les contributions sont les bienvenues. Veuillez suivre les pratiques de codage établies et soumettre des pull requests pour toute amélioration ou correction de bug.

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails (si présent).

