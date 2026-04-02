**[English GUIDE](GUIDE.md)**

# Instrukcja Wdrożenia i Użytkowania

## Wymagania Wstępne
1. Czysty serwer VPS z systemem **Ubuntu**.
2. Domena internetowa z rekordem `A` oraz subdomeną wildcard `*` wskazującymi na adres IP Twojego VPS.

---

## Krok 1: Instalacja GIT i Ansible lokalnie na komputerze (jeśli jeszcze nie masz ich zainstalowanych)
Dla dystrybucji opartych na Debianie/Ubuntu (np. Linux Mint): 
```bash
sudo apt update
```
```bash
sudo apt install git
```
```bash
sudo apt install ansible
```

## Krok 2: Klonowanie Repozytorium
Pobierz kod projektu na swój lokalny komputer:
```bash
git clone https://github.com/jakubglazik5/aitm-infrastructure-automation.git
```

## Krok 3: Generowanie klucza SSH
Wygeneruj klucz za pomocą komendy (najepiej zostawić domyślny folder .ssh):
```bash
ssh-keygen -t ed25519 -C "nazwa do utrzymania porządku (np. evilginx_key)"
```
Dodaj klucz do swojego servera

## Krok 4: Konfiguracja
Przejście do folderu z konfiguracją:
```bash
cd aitm-infrastructure-automation/ansible_with_docker
```
Otwórz plik inventory.ini i wpisz adres IP twojego serwera oraz ścieżkę do PRYWATNEGO klucza ssh (bez końcówki .pub):
```bash
nano inventory.ini
```

Zapisz zmiany i wyjdź z edytora:

Ctrl+o

ENTER

Ctrl+x


## Krok 5: Wdrożenie Infrastruktury
Uruchom playbook ansible za pomocą komendy:
```bash
ansible-playbook -i inventory.ini ansible/deploy_app.yml
```

## Krok 6: Zarządznie firewallem i Certyfikatami SSL:
Evilginx do poprawnego działania potrzebuje aktualnych certyfikatów SSL, a nasza konfiguracja firewalla z geoblockingiem przepuszcza ruch sieciowy tylko z polskich adresów IP broniąć server przed większością skanerów (większość skanerów pochodzi od firm związanych z cyberbezpieczeństwem z USA), ale też uniemożliwia pobranie certyfikatów.

Rozwiązaniem są dwa skrypty wysłane za pomocą ansible na server, czyli open_ports.sh oraz close_ports.sh. 

Skrypt open_ports.sh służy do przepuszczenia ruchu w celu pobrania certyfikatów, a close_ports.sh do przywrócenia bezpiecznej konfiguracji zabezpieczającej nas przed skanerami.
Oprócz tych dwóch plików dołączyłem także skrypt aktualizujący liste polskich (domyślnie, można zmienić na inny kraj) adresów IP. Warto go użyć raz na jakiś czas.

Łączymy sie z serverem (np. za pomocą wygenerowanego wcześniej klucza, który dodaliśmy do naszego serwera):
```bash
ssh root@ADRES_IP_TWOJEGO_SERWERA
```

Aktualizujemy liste polskich adresów IP:
```bash
cd ~/firewall_scripts
```
```bash
./update_ips.sh
``` 

Otwieramy ruch w celu pobrania certyfikatów (im krócej porty są wystawione na świat, tym mniej skanerów zdąży sprawdzić nasz serwer):
```bash
./open_ports.sh
```

Uruchamiamy konsole evilginx:
```bash
docker attach evilginx_server
```
Jeśli w terminalu nic się nie pojawia, klikamy klika razy enter. Powinien pojawić sie znak zachęty ":". To oznacza, że narzędzie jest uruchomione a my znajdujemy sie w głównej konsoli.

Do poprawnego działania narzędzia musimy skonfigurować naszą domenę oraz adres IP serwera:
```bash
config domain TWOJA_NAZWA_DOMENY
```
```bash 
config ipv4 ADRES_IP_TWOJEGO_SERWERA
```

Sprawdzamy czy pobieranie certyfikatóww jest możliwe przy pomocy dołączonego do narzędzia przykładu:
```bash
phishlets hostname example TWOJA_NAZWA_DOMENY
```

```bash
phishlets enable example
```

Po pomyślnym pobraniu certyfikatów wychodzimy z evilginx, uszczelniamy z powrotem nasz firewall i wracamy do narzędzia:

Ctrl+P

Ctrl+Q

```bash
./close_ports.sh
```

Co do użytkowania samego narzędzia oraz pisania własnych phishletów odsyłam was do kursu autora narzędzia Kuby Gretzkiego oraz poradników na youtube.

## Przydatne komendy i skróty klawiszowe:
Całkowite wyłączenie narzędzia na poziomie dockera:
```bash
docker compose down
```

Postawienie kontenera po całkowitym wyłączeniu:
```bash
docker compose up -d
```

Zatrzymanie działania narzedzia na poziomie dockera:
```bash
docker compose stop
```

Uruchomienie ZATRZYMANEGO kontenera:
```bash
docker compose start
```

Uruchomienie narzędzia:
```bash
docker attach evilginx_server
```

Wyjście z konsoli narzędzia pozostawiając ją działająca w tle:

Ctrl+P

Ctrl+Q


Wyjście z konsoli narzędzia przerywając proces:
```bash
exit
```

Wejście do folderu z phishletami:
```bash
cd /opt/evilginx/phishlets
```

## Porada odnośnie firewalla
Geoblocking chroni nas przed większością skanerów, jednak Polska również posiada własne boty skanujące internet w poszukiwaniu takich serwerów, jeśli konfiguracja nie jest używana jako prezentacja/szkolenie, a jedynie do domowych testów, zalecam ustawienie drugiego firewalla bezpośrednio w panelu dostawcy waszego VPS. Zwiększy to drastycznie żywotność waszego serwera.

W panelu ustawiamy porty TCP 22, 80 i 443 na adres publiczny naszego routera domowego. 22 jest opcjonalny, ale chroni server przed atakami brute-force na protokół SSH.

Taka konfiguracja zatrzyma resztę skanerów, co umożliwi spokojne testy w obrębie naszej sieci Wi-Fi.

Przy pobieraniu certyfikatów SSL przez Let's Encrypt należy chwilowo przepuścić ruch sieciowy przez porty 80 i 443 z obu firewalli.

Adres publiczny swojego routera sprawdzicie łącząc się do swojej sieci i wpisując komendę:
```bash
curl ifconfig.me
```

Jeśli chodzi przestawienie naszego geoblockingu na adresy ip kraju innego niż Polska, to wystarczy w pliku update_ips.sh zmienić COUNTRY_CODE. Najlepiej zmienić to przed uruchomieniem pliku inventory.ini.

Przykład na podstawie Niemiec:

```bash
COUNTRY_CODE="de"
```

Jeśli zakończyłeś konfiguracje serwera, ale jednak chcesz zmienić ustawieia geoblockingu na inny kraj, to oprócz powyższego skryptu, musisz wyczyścić wszystkie aktywne połączenia za pomocą komend:
```bash
sudo apt install conntrack
```
```bash
sudo conntrack -F
```

Link do strony z listą dwuliterowych kodów państwa, z której korzysta skrypt: http://www.ipdeny.com/ipblocks/
