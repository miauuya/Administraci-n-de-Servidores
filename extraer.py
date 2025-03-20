import re
import requests
from bs4 import BeautifulSoup, Comment

if __name__ == '__main__':
    url = "http://127.0.0.1:8000/victima.html"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")

##------correos---------##
    est = re.compile('\w+@\w+.\w+')
    correos = soup.find_all(string=est)
    for correo in correos:
	    print(correo)

    mail = soup.find_all("a", attrs={"href": re.compile("^mailto:")})
    email = [a["href"] for a in mail]
    for mail in email:
        print(mail)

##-------comentarios-------##
    comment = soup.find_all(string=lambda string:isinstance(string, Comment))
    for com in comment:
        print(com)

