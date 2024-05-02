from openai import OpenAI
client = OpenAI(api_key="sk-proj-KFjJgFUtDwkAf5JZZXsST3BlbkFJCL6PYgl8wFDFCy28AH4d")

response = client.chat.completions.create(
  model="gpt-3.5-turbo",
  messages=[
    {"role": "user", "content": "Who won the world series in 2020?"},
    {"role": "assistant", "content": "The Los Angeles Dodgers won the World Series in 2020."},
  ]
)

print(response.choices[0].message.content)
print(response.choices[1].message.content)