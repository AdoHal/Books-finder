# Books-finder

A new Flutter project for finding IT books using https://api.itbook.store/ API. 

# Rozdiely a komentár

Hlavne rozdiely oproti predchádzajúcej verzii je upravene načítavanie kníh(načítava už všetky) a pridanie testov.

Čo sa týka načítavania, pri TypeAhead poli som nechal zobraziť len prvú stránku výsledkov(max 10). Snažil som sa to prerobiť, ale keďže je to implementovane pomocou packagu, tak som tam toho nevedel veľa pomeniť, hlavný problém bol so spúšťaním načítavania nových kníh, keďže vyhľadávanie suggestions sa vykonáva pri písaní a nepodarilo sa mi to spustiť aj pri scrollovani. 

Pri vyhľadávaní pomocou textového poľa a potvrdení tlačidlom som postupne načítavanie implementoval. Keďže api ponuka vyhľadávanie po stránkach, využil som tuto možnosť. A aj keď sa mi zdalo, že pri takomto postupe nie je veľmi pravdepodobne načítanie duplicitných kníh, ošetril som to pomocou hashmapy, ktorá je z počiatku prázdna, ale ak začneme načítavať knihy z netu, kontroluje sa to voči hashmape. Ak v nej záznam nie je, pridáme ho do nej a ak tam záznam je, odstránime ho z poľa kníh. Pred prechodom na screen s listom kníh je načítaná prvá stránka a ta je ako argument poslaná danému screenu. Všetky ostatne stránky sa načítavajú už v ňom. Pre zisťovanie scrollovania som využil scrollcontroller s listenerom, v ktorom vyhodnocujem podmienky a ak zistím, že scrollovanie je na konci, zavolá sa funkcia, ktorá načíta ďalšiu stránku. Pri scrollovani som pridal aj tlačidlo, ktoré pozíciu  na začiatok.

Pre prípad, že by sme sa snažili načítavať stránky stále a stále aj v prípade, že by žiadne ďalšie neexistovali som si z celkového poctu kníh vypočítal počet stránok. Ak teda scrollujeme ďalej, ale ďalšie stránky už neexistujú, nevolá sa funkcia načítania ďalších kníh. 
Ďalšia načítaná stránka je tak isto prekontrolovaná voči hashmape a následne pridaná k nášmu existujúcemu poľu. Knihy z poľa už následne nemažem. Nove pole je vytvorené stále pri prechode na screen s listom kníh, rovnako aj vyprázdnená hashmapa.

Posnažil som sa zaviesť aj cachovanie. Využil som flutter_cache_manager a pomocou neho volám načítavania kníh v RestServices. Všetky nastavenia som ponechal tak ako boli, akurát som to vyskúšal a fénovalo to podľa mňa celkom fajn. Vytvoril som providera na RestService, keďže som chcel aby 2 rozdielne triedy využívali rovnakú hashmapu na kontrolovanie kníh. A teda využívajú rovnakú referenciu RestService, kde je uložená hashmapa. 

Upravil som taktiež nejaké drobnosti o ktorých sme sa bavili, pridal par podmienok správnosti, try catch v RestService a informácie o nejakej chybe sa teraz zobrazujú aj používateľovi.

Následne som vytvoril pár testov. Myslím že ich nemusím nejak popisovať, napíšem radšej to, čo mi otestovať nešlo. Mal som problém pri testovaní TypeAhead, kde som sa nevedel dostať k návrhom. Po implementovaní cache som sa snažil namockovat aj ten, ale nejako to nechcelo fungovať a stále sa snažil vytvárať nejaké http requesty aj napriek tomu, že som mal celu funkciu ".getSingleFile()" namockovanu. V dôsledku toho zlyhávali testy. Posledný problém, na ktorý si spomínam bol s NetworkImage, kde testy zlyhávali na tom, že sa snažili získať obrázok z netu. K tomu som našiel package, ktorý mockuje automaticky NetworkImage a využil ho.
