@Grab(group="org.seleniumhq.selenium", module="selenium-java", version="2.42.2")
@Grab('org.mongodb:mongodb-driver:3.2.2')

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.*;
import com.mongodb.*

// Config Webdriver
System.setProperty("webdriver.chrome.driver", "sources/chromedriver");
ChromeOptions chromeOptions = new ChromeOptions();
chromeOptions.addArguments("--verbose", "--ignore-certificate-errors");
WebDriver driver = new ChromeDriver();

// Web Scraping
def data = [];
try {
    driver.get("https://stackoverflow.com/questions");
    List<WebElement> questions = driver.findElements(By.cssSelector("div.question-summary"));
    for(WebElement e : questions) {
        DBObject question = new BasicDBObject();
        question.put("title", e.findElement(By.cssSelector("h3 > a")).getText());
        question.put("vote", e.findElement(By.cssSelector("span.vote-count-post")).getText());
        question.put("answer", e.findElement(By.cssSelector("div.status > strong")).getText());
        question.put("view", e.findElement(By.cssSelector("div.views")).getText().split(" ")[0]);
        question.put("time", e.findElement(By.cssSelector("span.relativetime")).getText());
        
        data.add(question);
    }

    driver.close();
    driver.quit();
} catch(Exception e) {
    log.info "Exception encountered : " + e.message
}

println data;

// Connect MongoDB
mongo = new MongoClient('localhost', 27017);
db = mongo.getDB('webscraping');
collection = db.getCollection('groovy').insert(data);
