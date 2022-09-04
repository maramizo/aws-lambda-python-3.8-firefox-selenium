import json
from selenium import webdriver
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from utils import get_title


def lambda_handler(event, context):
    options = FirefoxOptions()
    options.headless = True
    options.binary_location = '/usr/local/bin/firefox'

    driver = webdriver.Firefox(executable_path='/usr/local/bin/geckodriver',
                               log_path='/tmp/geckodriver.log',
                               service_log_path='/tmp/service.log',
                               options=options)

    title = get_title(driver)
    print(title)

    driver.quit()

    return {
        'statusCode': 200,
        'body': json.dumps("LGTM")
    }


if __name__ == '__main__':
    kappa_handler = lambda_handler({}, {})
    print(kappa_handler)
