import configparser
from openai import OpenAI
import re

from torch.optim.rprop import rprop

from test import finalResult


class MyChatBot:
    def __init__(self):
        self.config = configparser.ConfigParser()
        self.config.read('config/config.ini')
        self.key = self.config['ai_key']['openai']
        self.client = OpenAI(api_key=self.key)
        self.model_type = 'gpt-4o'
        self.model = None
        self.chat_template = None
        self.chat_chain = None
        self.system_input = None
        self.user_input = None
        self.with_message_history = None
        self.session_id = None
        self.config = None
        self.store = {}
        self.message = []

    def change_model(self, model):
        self.model = model

    def change_message(self, prompt):
        SYSTEM_PROMPT = (
            "You're the steak expert."
            "Please use your expertise to evaluate steak restaurants in Los Angeles, USA,"
            "And give me recommendations based primarily on customer sources and online reviews."
            "Please provide the top 2 restaurant  and list the information in the following format"
            "name:"
            "address:"
            "phone:"
            "menu:"
            "reason:"
        )

        try:
            response = self.client.chat.completions.create(
                model="gpt-4",  # Adjust model as needed
                messages=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=784  # Adjust as necessary
            )
            # print(response.choices[0].message.content.strip())
            result =  self.get_result(response.choices[0].message.content.strip())
            return result
        except Exception as e:
            print(f"Error connecting to OpenAI API: {e}")
            return None

    def get_result(self, response):
        print(response)
        pattern = re.compile(
            r"(?:(?:\d+[.)]?\s*)?\n?)"  # Match numbering like '1.', '1)', or '1)\n'
            r"Name:\s*(?P<name>.+?)\s*"
            r"Address:\s*(?P<address>.+?)\s*"
            r"Phone:\s*(?P<phone>.+?)\s*"
            r"Menu:\s*(?P<menu>.+?)\s*"
            r"Reason:\s*(?P<reason>.+?)(?=\n\d+[.)]?\s*Name:|$)",  # Lookahead for next entry or end of string
            re.DOTALL | re.IGNORECASE,
        )

        finalResult = {}

        restaurants = []

        # Iterate through all matches
        for match in pattern.finditer(response):
            restaurant = {
                "name": match.group("name").strip(),
                "address": match.group("address").strip(),
                "phone": match.group("phone").strip(),
                "menu": match.group("menu").strip(),
                "reason": match.group("reason").strip(),
            }
            restaurants.append(restaurant)

        finalResult["restaurantData"] = restaurants
        finalResult["responseStatus"] = 'Ok'
        finalResult["responseResult"] = "Success get the restaurants data"
        return finalResult

# a = MyChatBot()
# result = a.change_message("What are the best steak restaurants in LA?")
# print(a.get_result(result))
