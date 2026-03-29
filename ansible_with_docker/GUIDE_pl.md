# Instrukcja Wdrożenia i Użytkowania

## Wymagania Wstępne
1. Czysty serwer VPS z systemem **Ubuntu**.
2. Domena internetowa z rekordem `A` oraz poddomenami (np. do logowania) wskazującymi na adres IP Twojego VPS.
3. Dostęp SSH do serwera (najlepiej oparty na kluczach publicznych).

---

## Krok 1: Instalacja Ansible lokalnie na twoim komputerze (jeśli jeszcze go nie masz)
Linux mint: sudo apt install ansible

## Krok 2: Klonowanie Repozytorium
Pobierz kod projektu na swój lokalny komputer:
```bash
git clone https://github.com/jakubglazik5/aitm-infrastructure-automation.git
```
## Konfiguracja
Prejście do folderu z konfiguracją:
```bash
cd aitm-infrastructure-automation/ansible_with_docker
```
Otwórz plik inventory.ini i wpisz adres IP twojego servera:
```bash
nano inventory.ini
```

Aby zapisać zmiany i wyjść:
```bash
ctrl o
ENTER
ctrl x
```

## Krok 3: Wdrożenie Infrastruktury
Uruchom playbook ansible za pomocą komendy:
```bash
ansible-playbook -i inventory.ini ansible/deploy_app.yml
```

## Krok 4: Zarządznie firewallem i Certyfikatami SSL:
Evilginx do poprawnego działania potrzebuje aktualnych certyfikatów SSL, a nasza konfiguracja firewalla z geoblockingiem przepuszcza ruch sieciowy tylko z polskich adresów IP broniąć server przed większością skanerów (większość skanerów pochodzi od firm związanych z cyberbezpieczeństwem z USA), ale też uniemożliwia pobranie certyfikatów. Rozwiązaniem są dwa skrypty wysłane za pomocą ansible na server, czyli open_ports.sh oraz close_ports.sh. 
open_ports.sh służy do przepuszczenia ruchu w celu pobrania certyfikatów, a close_ports.sh do przywrócenia bezpiecznej konfiguracji zabezpieczającej nas przed skanerami.
Oprócz tych dwóch plików dołączyłem także skrypt aktualizujący liste poslich adresów IP. Warto go użyć raz na jakiś czas.

Aktualizujemy liste polskich adresów IP:
```bash
cd ~/firewall_scripts
./update_pl_ips.sh
``` 

Otwieramy ruch w celu pobrania certyfikatów (im krócej porty są wystawione na świat, tym mniej skanerów zdąży sprawdzić nasz server):
```bash
cd ~/firewall_scripts
./open_ports.sh
```

Uruchamiamy konsole evilginx:
```bash
docker attach evilginx_server
```

Po pomyślnym pobraniu certyfikatów uszczelniamy z powrotem nasz firewall:
```bash
cd ~/firewall_scripts
./close_ports.sh
```
