import requests
import sys

def scan_url(target_url, word):
    """Escanea un sitio web buscando una palabra específica en las rutas."""

     # Construye la URL de prueba
    full_url = f"{target_url.rstrip('/')}/{word}"
    try:
        response = requests.get(full_url, timeout=5)

        # Si la respuesta es 200, el recurso existe
        if response.status_code == 200:
            print(f"Encontrado: {full_url} (Código {response.status_code})")
        elif response.status_code == 403:
            print(f"Acceso denegado: {full_url} (Código {response.status_code})")
        elif response.status_code == 404:
            print(f"No encontrado: {full_url} (Código {response.status_code})")
        else:
            print(f"Estado desconocido: {full_url} (Código {response.status_code})")
    except requests.exceptions.RequestException as e:
        print(f"Error al conectar con {full_url}: {e}")



if __name__ == '__main__':
    TARGET_URL = "http://127.0.0.1:8000"
    archivo = sys.argv[1]

    palabras = []
    with open(archivo, "r") as cadenas:
        for linea in cadenas:
            palabras.append(linea)
    for i in range(len(palabras)):
        WORD_TO_SEARCH = palabras[i]
        print(f"Buscando '{WORD_TO_SEARCH}' en {TARGET_URL}...\n")
        scan_url(TARGET_URL, WORD_TO_SEARCH)
        

