# Adversary-in-the-Middle (AitM) Infrastructure Automation

## O projekcie
Projekt ten stworzyłem w celu praktycznej nauki automatyzacji, konteneryzacji, konfiguracji zapór sieciowych oraz głębszego zrozumienia mechaniki zaawansowanych ataków phishingowych, a przede wszystkim metod skutecznej obrony przed nimi. Zainteresowałem się tym tematem podczas wykładów oraz zajęć projektowych na przedmiocie Wytwarzanie Aplikacji Webowych realizowanym na Politechnice Gdańskiej.

## Dlaczego AitM i kradzież sesji?
Klasyczny phishing traci na skuteczności. Nowoczesne podejście wykorzystuje technikę **Adversary-in-the-Middle (AitM)** z użyciem serwerów reverse proxy. Atak ten pozwala na przechwycenie nie tylko danych logowania, ale przede wszystkim tokenów sesyjnych autoryzowanego użytkownika. Posiadanie takiego tokenu umożliwia ominięcie mechanizmów uwierzytelniania wieloskładnikowego (MFA/2FA), co czyni ten wektor ataku wyjątkowo niebezpiecznym.

## Wyzwanie Operacyjne i Rozwiązanie
Serwery testowe wystawione na działanie internetu są błyskawicznie flagowane i blokowane przez zautomatyzowane skanery bezpieczeństwa. Atakujący wykorzystują zaawansowane techniki zaciemniania kodu (obfuscation), stosowanie osobnych serwerów dla narzędzia i strony podszywającej się pod witrynę oraz tunelowanie za pomocą Cloudflare, aby ukryć się przed detekcją. Nam w celach testowych wystarczy firewall ze skonfigurowanym geoblockingiem, który będzie przepuszczał ruch wyłącznie z polskich adresów IP lub tylko z adresu powiązanego z naszym domowym routerem – zależnie od tego, czy używamy konfiguracji do sprawdzenia własnych urządzeń, czy przygotowujemy pokaz na żywo z udziałem uczestników.

Aby rozwiązać problem ciągłego i żmudnego konfigurowania środowiska, zaimplementowałem podejście **Infrastructure as Code**. 
Wykorzystując narzędzie **Ansible**, zautomatyzowałem cały cykl stawiania nowej infrastruktury. Playbooki samoczynnie:
* Konfigurują system Linux.
* Zarządzają ruchem sieciowym (zapory GeoIP za pomocą `iptables`).
* Uruchamiają aplikację w odizolowanym środowisku **Docker** (opcjonalnie).

Dzięki temu wdrożenie w pełni operacyjnego, zabezpieczonego przed skanerami serwera zajmuje zaledwie kilka minut.

## Zastrzeżenie
Projekt ma charakter wyłącznie edukacyjny. Repozytorium nie zawiera gotowych szablonów (phishletów) umożliwiających przeprowadzenie ataku na rzeczywiste usługi. Oszczędzi jednak sporo czasu tym, którzy chcą przetestować podatność własnej aplikacji webowej lub po prostu są ciekawi, jak taki atak wygląda w praktyce.

## Kilka porad wdrożeniowych
* **Wersja Ansible:** Znacznie wygodniejsza w użytkowaniu, jeśli serwer VPS ma służyć wyłącznie do szybkich testów z użyciem Evilginx. 
* **Wersja Ansible z Dockerem:** Zalecana, jeśli zależy Ci na pełnej izolacji środowiska, braku konfliktów zależności w głównym systemie operacyjnym oraz możliwości błyskawicznego usunięcia narzędzia z servera.
