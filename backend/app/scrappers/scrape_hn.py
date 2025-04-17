import time
import logging
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service


# Configurar logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Configurar el navegador en modo headless
options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

# Instanciar el driver con WebDriverManager
driver = webdriver.Chrome(options=options)

def fetch_hacker_news_top_stories(pages=5):
    base_url = "https://news.ycombinator.com/news"
    results = []

    for page in range(1, pages + 1):
        url = f"{base_url}?p={page}"
        logging.info(f"Accediendo a: {url}")

        try:
            driver.get(url)
            time.sleep(1)  # Evitar ser bloqueado por el servidor

            titles = driver.find_elements(By.CLASS_NAME, "titleline")
            subtexts = driver.find_elements(By.CLASS_NAME, "subtext")

            for i in range(min(len(titles), len(subtexts))):
                title_el = titles[i]
                subtext_el = subtexts[i]

                title = title_el.text
                link = title_el.find_element(By.TAG_NAME, "a").get_attribute("href")

                try:
                    score_el = subtext_el.find_element(By.CLASS_NAME, "score")
                    score_text = score_el.text.split()[0]  # "123 points" → "123"
                    score = int(score_text)
                except:
                    score = 0  # En caso de que no tenga votos

                results.append({
                    "title": title,
                    "url": link,
                    "score": score
                })

        except Exception as e:
            logging.error(f"Error en la página {page}: {e}")
            continue

    return results

if __name__ == "__main__":
    stories = fetch_hacker_news_top_stories(pages=5)
    for i, story in enumerate(stories, start=1):
        print(f"\n{i}. {story['title']}")
        print(f"   Score: {story['score']}")
        print(f"   URL: {story['url']}")

    driver.quit()
