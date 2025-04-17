# scrape_books.py

import requests
from bs4 import BeautifulSoup
from ..services.redis_client import r
import json
import hashlib
import logging
import time

# Configuración de logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


BASE_URL = "https://books.toscrape.com/catalogue/page-{}.html"
BOOK_BASE_URL = "https://books.toscrape.com/catalogue/"
MAX_BOOKS = 100
PRICE_THRESHOLD = 20.0

def get_book_id(title, price, category):
    unique_str = f"{title}-{price}-{category}"
    return hashlib.md5(unique_str.encode()).hexdigest()

def get_book_category(detail_url):
    try:
        response = requests.get(detail_url, timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')
        breadcrumb_links = soup.select('ul.breadcrumb li a')
        if len(breadcrumb_links) >= 3:
            return breadcrumb_links[2].text.strip()
    except Exception as e:
        logging.warning(f"No se pudo obtener la categoría para {detail_url}: {e}")
    return "Unknown"

def scrape_books():
    books_scraped = 0
    page = 1

    while books_scraped < MAX_BOOKS:
        try:
            response = requests.get(BASE_URL.format(page), timeout=10)
            response.raise_for_status()
        except requests.RequestException as e:
            logging.error(f"Error al obtener la página {page}: {e}")
            time.sleep(5)
            continue

        soup = BeautifulSoup(response.text, 'html.parser')
        articles = soup.find_all('article', class_='product_pod')

        if not articles:
            logging.info("No se encontraron más libros.")
            break

        for article in articles:
            if books_scraped >= MAX_BOOKS:
                break

            try:
                title = article.h3.a['title']
                price_text = article.find('p', class_='price_color').text
                price = float(price_text.replace('£', '').replace('Â', ''))

                # Imagen
                image_url = 'https://books.toscrape.com/' + article.find('img')['src'].replace('../', '')

                # URL del detalle del libro
                relative_url = article.h3.a['href'].replace('../../../', '')
                detail_url = BOOK_BASE_URL + relative_url

                # Obtener categoría desde la página individual
                category = get_book_category(detail_url)

                if price < PRICE_THRESHOLD:
                    book_id = get_book_id(title, price, category)
                    book_data = {
                        'title': title,
                        'price': price,
                        'category': category,
                        'image_url': image_url
                    }
                    r.set(f'book:{book_id}', json.dumps(book_data))
                    books_scraped += 1
                    logging.info(f"✅ Libro almacenado: {title} ({category})")

            except Exception as e:
                logging.error(f"❌ Error procesando libro: {e}")
                continue

        page += 1
        time.sleep(1)  # Pausa para evitar sobrecargar el servidor

if __name__ == '__main__':
    scrape_books()
