# Przetwarzanie-obrazow-matlab
Detekcja wybranych składników skalnych w obrazie mikroskopowym piaskowca godulskiego 

 Metodyka przetwarzania obrazu 
 
Analizie podlegały zdjęcia mikroskopowe piaskowca godulskiego przy świetle przechodzącym (1N) oraz odbitym (NX) wykonane przy 
dwudziestokrotnym powiększeniu. Zadaniem była detekcja poszczególnych minerałów przy następujących założeniach: 
 kwarc - przy 1N przeźroczysty, przy XN zmieniający kolor od białego via szary do czarnego; 
 glaukonit - przy 1N i XN zielony; 
 przestrzeń porowa: 1N - przeźroczysty, przy XN - tylko czarny bez względu na rotacje; 
 węglany: 1N - przeźroczyste, przy XN - od "pastelowych" do czarnego; 
 minerały nieprzeźroczyste - przy 1N barwne i "masywne", przy XN jednokolorowe, nie zmieniają barwy z rotacją; 
 miki (minerały blaszkowe) - minerały cechujące się łupliwością, przy 1N na ogół lekki odcień, przy XN zmieniają kolor 
faliście (odmiany żółte, niebieskie, brązowe, czerwone)  elementy mniejsze niż 20x20px mają być ignorowane 
Rozpoznawanie minerałów następowało po kolei z wykluczeniem obszarów już zaklasyfikowanych , zaczynając od glaukonitu, następnie
kwarc, miki, minerały nieprzezroczyste i na końcu przestrzeń porowa. Nie przeprowadzano ekstrakcji węglanów za pomocą programu, ponieważ 
nie rozpoznano ich na analizowanych zdjęciach. 
Ekstrakcję poszczególnych składników rozpoczęto od stworzenia binarnego obrazu przyjmując pewne wartości pikseli i zależności
między nimi. Następnie powstały obraz poddawano szeregowi przekształceń morfologicznym takim jak operacja otwarcia, zamknięcia, 
erozji, dylatacji oraz wybrane parametry funkcji bwmorph. Wreszcie binarny obraz etykietowano i po usunięciu elementów o zbyt 
małej powierzchni liczono sumaryczne pole zajmowane przez wybrany składnik. Na końcu obliczono pola powierzchni składników w mm2 i skład 
procentowy próbki. 
 
