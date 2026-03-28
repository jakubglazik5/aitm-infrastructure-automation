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
git clone <https://github.com/jakubglazik5/aitm-infrastructure-automation.git>
```
## Konfiguracja
Prejście do folderu z konfiguracją:
```bash
cd <aitm-infrastructure-automation/ansible_with_docker>
```
Otwórz plik inventory.ini i wpisz adres IP twojego servera:
```bash
nano inventory.ini
```

Aby zapisać zmiany i wyjść:
ctrl o
ENTER
ctrl x

## Krok 3: Wdrożenie Infrastruktury
```bash
ansible-playbook -i inventory.ini ansible/deploy_app.yml
```
